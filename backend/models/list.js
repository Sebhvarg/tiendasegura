const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const listOfProductsSchema = new Schema(
    {
        products: [
            { type: Types.ObjectId, ref: 'Product' }, { default: [] }
        ],
        price: { type: Number, required: true, min: 0.05 },
        isActive: { type: Boolean, default: true },

    },
    { timestamps: true }
);

const List = model('List', listOfProductsSchema);

module.exports = List;