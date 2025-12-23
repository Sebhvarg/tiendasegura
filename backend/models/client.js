const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const clientSchema = new Schema(
    {
        name: { type: String, required: true, trim: true },
        email: { type: String, required: true, trim: true, unique: true },
        phone: { type: String, trim: true, default: '' },
        address: { type: String, trim: true, default: '' },
        shoppingCart: {shoppingCart: [{ type: Types.ObjectId, ref: 'ShoppingCart' }], default: [] },
        isActive: { type: Boolean, default: true },

    },
    { timestamps: true }
);

const Client = model('Client', clientSchema);

module.exports = Client;