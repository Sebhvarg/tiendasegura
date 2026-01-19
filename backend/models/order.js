const mongoose = require('mongoose');
const OrderStatus = require('../enum/orderStatus');
const ShoppingCart = require('./shopping_cart');
const List = require('./list');

const { Schema, model, Types } = mongoose;

const orderSchema = new Schema(
    {
        client: { type: Types.ObjectId, ref: 'Client', required: true },
        shop: { type: Types.ObjectId, ref: 'Shop', required: true },
        products: [
            {
                product: { type: Types.ObjectId, ref: 'Product' },
                name: String,
                price: Number,
                quantity: Number,
                image: String
            }
        ],
        address: { type: String, required: true },
        paymentMethod: { type: String, enum: ['Cash', 'Card'], required: true },
        totalPrice: { type: Number, min: 0.05 },
        status: { type: String, enum: Object.values(OrderStatus), default: OrderStatus.PENDING },
    },
    { timestamps: true }
);
const Order = model('Order', orderSchema);



module.exports = Order;