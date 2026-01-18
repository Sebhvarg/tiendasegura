const mongoose = require('mongoose');
const Shop = require('../models/shop');
const Catalog = require('../models/catalog');
const ShopOwner = require('../models/shop_owner');

// @desc    Crear una nueva tienda y su catálogo
// @route   POST /api/shops
// @access  Private (Seller/ShopOwner)
exports.createShop = async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const { name, address } = req.body;
    const userId = req.user._id;

    if (!name || !address) {
      return res.status(400).json({
        success: false,
        message: 'Por favor proporciona nombre y dirección de la tienda'
      });
    }

    // 1. Buscar al ShopOwner asociado al usuario
    const owner = await ShopOwner.findOne({ user: userId }).session(session);
    if (!owner) {
      await session.abortTransaction();
      session.endSession();
      return res.status(404).json({
        success: false,
        message: 'Propietario no encontrado. Asegúrate de ser un vendedor registrado.'
      });
    }

    // 2. Generar IDs para Shop y Catalog mutuamente dependientes
    const shopId = new mongoose.Types.ObjectId();
    const catalogId = new mongoose.Types.ObjectId();

    // 3. Crear Tienda
    const newShop = new Shop({
      _id: shopId,
      name,
      address,
      shopOwner: owner._id,
      catalog: catalogId,
      isActive: true
    });

    // 4. Crear Catálogo
    const newCatalog = new Catalog({
      _id: catalogId,
      shop: shopId,
      products: [],
      isActive: true
    });

    // 5. Guardar ambos
    await newShop.save({ session });
    await newCatalog.save({ session });

    // 6. Actualizar ShopOwner
    owner.shops.push(shopId);
    await owner.save({ session });

    await session.commitTransaction();
    session.endSession();

    res.status(201).json({
      success: true,
      message: 'Tienda creada exitosamente',
      data: {
        shop: newShop,
        catalog: newCatalog
      }
    });

  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    console.error('Error creando tienda:', error);
    res.status(500).json({
      success: false,
      message: 'Error al crear la tienda',
      error: error.message
    });
  }
};

// @desc    Obtener tiendas del usuario actual
// @route   GET /api/shops/my-shops
// @access  Private (Seller)
exports.getMyShops = async (req, res) => {
  try {
    const userId = req.user._id;

    // Buscar ShopOwner
    const owner = await ShopOwner.findOne({ user: userId }).populate('shops');
    
    if (!owner) {
        return res.status(404).json({
            success: false,
            message: 'No se encontró perfil de vendedor'
        });
    }

    res.status(200).json({
      success: true,
      data: owner.shops
    });
  } catch (error) {
    console.error('Error obteniendo mis tiendas:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener tus tiendas',
      error: error.message
    });
  }
};
