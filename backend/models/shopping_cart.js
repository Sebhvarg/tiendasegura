const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const shoppingCartSchema = new Schema(
    {
        listOfProducts: [{ type: Types.ObjectId, ref: 'List' }],
        isActive: { type: Boolean, default: true },
        isEmpty: { type: Boolean, default: true },
        client: { type: Types.ObjectId, ref: 'Client', required: true },
    },
    { timestamps: true }
);
const ShoppingCart = model('ShoppingCart', shoppingCartSchema);

module.exports = ShoppingCart;