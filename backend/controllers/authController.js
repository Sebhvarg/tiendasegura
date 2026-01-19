const User = require('../models/user');
const Client = require('../models/client');
const ShopOwner = require('../models/shop_owner');
const ShoppingCart = require('../models/shopping_cart');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Función para generar JWT
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '7d'
  });
};

// @desc    Registrar nuevo usuario
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const { 
      name, 
      lastName, 
      username, 
      email, 
      address, 
      phone, 
      password, 
      DateOfBirth, 
      userType 
    } = req.body;

    let cedulaPhotoUrl = '';
    if (req.file) {
      cedulaPhotoUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    }


    if (!name || !lastName || !username || !email || !password || !userType) {
      return res.status(400).json({
        success: false,
        message: 'Por favor proporciona todos los campos requeridos'
      });
    }

    // Verificar si el usuario ya existe
    const userExists = await User.findOne({ $or: [{ email }, { username }] });
    
    if (userExists) {
      return res.status(400).json({
        success: false,
        message: 'El usuario o email ya existe'
      });
    }

    // Hashear password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Crear usuario
    const user = await User.create({
      name,
      lastName,
      username,
      email,
      address,
      phone,
      password: hashedPassword,
      password: hashedPassword,
      DateOfBirth,
      userType,
      cedulaPhotoUrl
    });

    // Si es customer, crear Client y ShoppingCart vacío
    let clientDoc;
    let shoppingCartDoc;
    let shopOwnerDoc;

    if (user.userType === 'customer') {
      clientDoc = await Client.create({ user: user._id });
      shoppingCartDoc = await ShoppingCart.create({
        client: clientDoc._id,
        listOfProducts: [],
        isEmpty: true,
      });
      clientDoc.shoppingCart = [shoppingCartDoc._id];
      await clientDoc.save();
    } 
    // Si es seller o shop_owner, crear ShopOwner
    else if (user.userType === 'seller' || user.userType === 'shop_owner') {
        shopOwnerDoc = await ShopOwner.create({
            user: user._id,
            shops: []
        });
    }

    // Generar token
    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente',
      data: {
        _id: user._id,
        name: user.name,
        lastName: user.lastName,
        username: user.username,
        email: user.email,
        userType: user.userType,
        token,
        clientId: clientDoc?._id,
        shoppingCartId: shoppingCartDoc?._id,
        shopOwnerId: shopOwnerDoc?._id,
      }
    });

  } catch (error) {
    console.error('Error en registro:', error);
    res.status(500).json({
      success: false,
      message: 'Error al registrar usuario',
      error: error.message
    });
  }
};

// @desc    Login de usuario
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validar campos
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Por favor proporciona email y contraseña'
      });
    }

    // Buscar usuario (incluyendo password para comparar)
    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas'
      });
    }

    // Verificar si el usuario está activo
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Usuario inactivo'
      });
    }

    // Verificar password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas'
      });
    }

    // Generar token
    // Generar token
    const token = generateToken(user._id);

    let clientId = null;
    let shopOwnerId = null;

    if (user.userType === 'customer') {
        const client = await Client.findOne({ user: user._id });
        if (client) clientId = client._id;
    } else if (user.userType === 'shop_owner' || user.userType === 'seller') {
        const owner = await ShopOwner.findOne({ user: user._id });
        if (owner) shopOwnerId = owner._id;
    }

    res.status(200).json({
      success: true,
      message: 'Login exitoso',
      data: {
        _id: user._id,
        name: user.name,
        lastName: user.lastName,
        username: user.username,
        email: user.email,
        userType: user.userType,
        token,
        clientId,
        shopOwnerId
      }
    });

  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({
      success: false,
      message: 'Error al iniciar sesión',
      error: error.message
    });
  }
};

// @desc    Obtener usuario actual
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password');
    let clientId = null;
    let shopOwnerId = null;

    if (user.userType === 'customer') {
        const client = await Client.findOne({ user: user._id });
        if (client) clientId = client._id;
    } else if (user.userType === 'shop_owner' || user.userType === 'seller') {
        const owner = await ShopOwner.findOne({ user: user._id });
        if (owner) shopOwnerId = owner._id;
    }

    res.status(200).json({
      success: true,
      data: {
        ...user.toObject(),
        clientId,
        shopOwnerId
      }
    });

  } catch (error) {
    console.error('Error al obtener usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener información del usuario',
      error: error.message
    });
  }
};

// @desc    Actualizar perfil de usuario
// @route   PUT /api/auth/updateprofile
// @access  Private
exports.updateProfile = async (req, res) => {
  try {
    const fieldsToUpdate = {
      name: req.body.name,
      lastName: req.body.lastName,
      address: req.body.address,
      phone: req.body.phone,
    };

    // Remover campos undefined
    Object.keys(fieldsToUpdate).forEach(key => 
      fieldsToUpdate[key] === undefined && delete fieldsToUpdate[key]
    );

    const user = await User.findByIdAndUpdate(
      req.user._id,
      fieldsToUpdate,
      { new: true, runValidators: true }
    ).select('-password');

    res.status(200).json({
      success: true,
      message: 'Perfil actualizado exitosamente',
      data: user
    });

  } catch (error) {
    console.error('Error al actualizar perfil:', error);
    res.status(500).json({
      success: false,
      message: 'Error al actualizar perfil',
      error: error.message
    });
  }
};

// @desc    Cambiar contraseña
// @route   PUT /api/auth/changepassword
// @access  Private
exports.changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: 'Por favor proporciona la contraseña actual y la nueva'
      });
    }

    const user = await User.findById(req.user._id);

    // Verificar contraseña actual
    const isMatch = await bcrypt.compare(currentPassword, user.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Contraseña actual incorrecta'
      });
    }

    // Hashear nueva contraseña
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);

    await user.save();

    res.status(200).json({
      success: true,
      message: 'Contraseña cambiada exitosamente'
    });

  } catch (error) {
    console.error('Error al cambiar contraseña:', error);
    res.status(500).json({
      success: false,
      message: 'Error al cambiar contraseña',
      error: error.message
    });
  }
};
