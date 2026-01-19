const Product = require('../models/product');
const Catalog = require('../models/catalog');
const List = require('../models/list');
const { searchProductImage } = require('../services/imageScraperService');

// @desc    Crear producto y agregarlo al catálogo del vendedor
// @route   POST /api/products/create
// @access  Private (Seller)
async function createProduct(req, res, next) {
  const session = await require('mongoose').startSession();
  session.startTransaction();
  try {
    const payload = req.body;
    const userId = req.user._id;

    // 1. Validar que el usuario sea un vendedor con tienda
    const ShopOwner = require('../models/shop_owner');
    const owner = await ShopOwner.findOne({ user: userId }).populate('shops').session(session);

    if (!owner || owner.shops.length === 0) {
      await session.abortTransaction();
      return res.status(403).json({ 
        success: false, 
        message: 'Debes tener una tienda registrada para crear productos.' 
      });
    }

    // Por ahora usamos la primera tienda (TODO: permitir elegir tienda)
    const shop = owner.shops[0];
    
    // 2. Buscar el catálogo de esa tienda
    const catalog = await Catalog.findOne({ shop: shop._id }).session(session);
    if (!catalog) {
      await session.abortTransaction();
      return res.status(500).json({ 
        success: false, 
        message: 'No se encontró el catálogo de tu tienda.' 
      });
    }
    
    // 3. Auto-búsqueda de imagen si es necesario
    if (req.file) {
      payload.imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    } else if (!payload.imageUrl && payload.name) {
      console.log(`🔍 Buscando imagen para: ${payload.name}`);
      const imageUrl = await searchProductImage(
        payload.name,
        payload.brand || '',
        payload.netContent,
        payload.netContentUnit
      );
      if (imageUrl) {
        payload.imageUrl = imageUrl;
      }
    }
    
    // 4. Crear el producto
    // Nota: createProduct es un static helper en el modelo, pero necesitamos pasar la sesión
    // Como el static helper usa `new this(payload).save()`, pasamos { session } en save.
    // Sin embargo, Product.createProduct del modelo original no acepta session.
    // Vamos a crear la instancia manualmente para controlar la sesión.
    
    const newProduct = new Product(payload);
    await newProduct.save({ session });

    // 5. Agregar al catálogo
    catalog.products.push(newProduct._id);
    await catalog.save({ session });

    // Explicitly set shop if not in payload (it shouldn't be valid in payload from client usually)
    // We already have 'shop' object from earlier
    newProduct.shop = shop._id;
    await newProduct.save({ session });

    await session.commitTransaction();
    session.endSession();

    res.status(201).json(newProduct);
  } catch (err) {
    await session.abortTransaction();
    session.endSession();
    next(err);
  }
}
async function getProduct(req, res, next) {
  try {
    const { id } = req.params;
    const product = await Product.findById(id).populate('shop').exec();
    if (!product) return res.status(404).json({ error: 'Product not found' });
    res.json(product);
  } catch (err) {
    next(err);
  }
}
async function getListProducts(req, res, next) {
    try {
        let products = await Product.find().populate('shop').lean();

        // Fix for missing shops:
        // Iterate over products, if shop is missing, try to find the catalog that contains it.
        const productsWithoutShop = products.filter(p => !p.shop);
        
        if (productsWithoutShop.length > 0) {
            console.log(`Found ${productsWithoutShop.length} products without shop. Attempting to recover...`);
            
            // We need to look up catalogs to find which shop owns these products
            // Optimization: Find all catalogs once? Or per product?
            // Let's iterate and update.
            for (let product of productsWithoutShop) {
                // Find catalog containing this product
                const catalog = await Catalog.findOne({ products: product._id }).populate('shop');
                
                if (catalog && catalog.shop) {
                    product.shop = catalog.shop;
                    console.log(`Recovered shop for product ${product.name}: ${catalog.shop.name}`);
                    
                    // Optional: Persist this fix to DB so we don't do it every time
                    // await Product.findByIdAndUpdate(product._id, { shop: catalog.shop._id });
                }
            }
        }

        res.json(products);
    } catch (err) {
        next(err);
    }
}

// agregar al catalogo
async function addToCatalog(req, res, next) {
  try {
    const { catalogId, productId } = req.params;
    const catalog = await Catalog.findById(catalogId);
    if (!catalog) return res.status(404).json({ error: 'Catalog not found' });
    catalog.products.push(productId);
    await catalog.save();
    res.json(catalog);
  }
  catch (err) {
    next(err);
  }
}

async function addToList(req, res, next) {
  try {
    const { listId, productId } = req.params;
    const list = await List.findById(listId);
    if (!list) return res.status(404).json({ error: 'listlog not found' });
    list.products.push(productId);
    await list.save();
    res.json(list);
  }
  catch (err) {
    next(err);
  }
}

// @desc    Buscar imagen de producto (Scraping/Bing/Google)
// @route   POST /api/products/search-image
// @access  Public (or Private)
async function searchImage(req, res, next) {
  try {
    const { name, brand, netContent, netContentUnit } = req.body;
    
    if (!name) {
      return res.status(400).json({ 
        success: false, 
        message: 'El nombre del producto es requerido' 
      });
    }

    console.log(`🔍 API Search Image: ${name} ${brand || ''}`);
    
    const imageUrl = await searchProductImage(
      name,
      brand || '',
      netContent,
      netContentUnit
    );

    res.json({
      success: true,
      imageUrl: imageUrl || null
    });
  } catch (err) {
    next(err);
  }
}

// @desc    Eliminar producto
// @route   DELETE /api/products/:id
// @access  Private (Seller/ShopOwner)
async function deleteProduct(req, res, next) {
    const session = await require('mongoose').startSession();
    session.startTransaction();
    try {
        const { id } = req.params;
        const product = await Product.findById(id).session(session);

        if (!product) {
             await session.abortTransaction();
             return res.status(404).json({ message: 'Producto no encontrado' });
        }

        // TODO: Verificar que el producto pertenece a la tienda del usuario (Auth check)
        // Por simplificación confiamos en que solo el dueño tiene acceso al botón en su catálogo

        // Eliminar referencias en catálogos
        await Catalog.updateMany(
            { products: id },
            { $pull: { products: id } }
        ).session(session);

        // Eliminar producto
        await Product.findByIdAndDelete(id).session(session);

        await session.commitTransaction();
        session.endSession();

        res.json({ success: true, message: 'Producto eliminado' });
    } catch (err) {
        await session.abortTransaction();
        session.endSession();
        next(err);
    }
}

// @desc    Actualizar producto
// @route   PUT /api/products/:id
// @access  Private (Seller/ShopOwner)
async function updateProduct(req, res, next) {
    try {
        const { id } = req.params;
        const updates = req.body;
        
        // Evitar actualizar campos inmutables si los hubiera
        delete updates._id; 
        delete updates.createdAt;

        if (req.file) {
            updates.imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
        }

        const product = await Product.findByIdAndUpdate(id, updates, { new: true });

        if (!product) {
            return res.status(404).json({ message: 'Producto no encontrado' });
        }

        res.json(product);
    } catch (err) {
        next(err);
    }
}

module.exports = {
  createProduct,
  getProduct,
  getListProducts,
  addToCatalog,
  addToList,
  searchImage,
  deleteProduct,
  updateProduct,
};