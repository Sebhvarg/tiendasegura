const mongoose = require('mongoose');
const OrderStatus = require('../enum/orderStatus');
const ShoppingCart = require('./shopping_cart');
const List = require('./list');

const { Schema, model, Types } = mongoose;

const orderSchema = new Schema(
    {
        client: { type: Types.ObjectId, ref: 'Client', required: true },
        shoppingCart: { type: Types.ObjectId, ref: 'ShoppingCart', required: true },
        totalPrice: { type: Number, min: 0.05 },
        status: { type: String, enum: Object.values(OrderStatus), default: OrderStatus.PENDING },
    },
    { timestamps: true }
);
const Order = model('Order', orderSchema);



module.exports = Order;