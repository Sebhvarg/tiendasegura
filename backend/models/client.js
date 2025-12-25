const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const clientSchema = new Schema(
    {   
        user: { type: Types.ObjectId, ref: 'User', required: true },
        shoppingCart: {shoppingCart: [{ type: Types.ObjectId, ref: 'ShoppingCart' }], default: [] },
    },
    { timestamps: true }
);

const Client = model('Client', clientSchema);

module.exports = Client;