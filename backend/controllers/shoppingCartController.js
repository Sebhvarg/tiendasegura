const ShoppingCart = require('../models/shopping_cart');

async function getShoppingCart(req, res, next) {
  try {
    // traer todos los carritos de compra
    const shoppingCarts = await ShoppingCart.find().exec();
    res.json(shoppingCarts);
  } catch (err) {
    next(err);
  } 
}
module.exports = {
  getShoppingCart,
};