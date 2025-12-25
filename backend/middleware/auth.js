const jwt = require('jsonwebtoken');
const User = require('../models/user');

// Middleware para proteger rutas
exports.protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Obtener token del header
      token = req.headers.authorization.split(' ')[1];

      // Verificar token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Obtener usuario del token (incluir password para que funcione select)
      req.user = await User.findById(decoded.id).select('-password');

      if (!req.user) {
        return res.status(401).json({ 
          success: false,
          message: 'Usuario no encontrado' 
        });
      }

      if (!req.user.isActive) {
        return res.status(401).json({ 
          success: false,
          message: 'Usuario inactivo' 
        });
      }

      next();
    } catch (error) {
      console.error('Error en autenticación:', error);
      return res.status(401).json({ 
        success: false,
        message: 'No autorizado, token inválido' 
      });
    }
  } else {
    return res.status(401).json({ 
      success: false,
      message: 'No autorizado, no hay token' 
    });
  }
};

// Middleware para autorizar roles específicos
exports.authorize = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.userType)) {
      return res.status(403).json({ 
        success: false,
        message: `El rol ${req.user.userType} no tiene permiso para acceder a esta ruta` 
      });
    }
    next();
  };
};
