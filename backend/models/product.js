const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const productSchema = new Schema(
    {
        name: { type: String, required: true, trim: true },
        description: { type: String, trim: true, default: '' },
        brand : { type: String, trim: true, default: '' },
        price: { type: Number, required: true, min: 0.05 },
        netContent: { type: Number, required: true, min: 0 },
        netContentUnit: { type: String, required: true, enum: Object.values(require('../enum/netContent')) },
        stock: { type: Number, default: 0, min: 0 },
        imageUrl: { type: String, default: null },
        isActive: { type: Boolean, default: true },
        shop: { type: Schema.Types.ObjectId, ref: 'Shop' },
    },
    { timestamps: true }
);

productSchema.index({ name: 'text', brand: 'text' });
productSchema.statics.createProduct = async function (payload) {
    const p = new this(payload);
    return p.save();
};

const Product = model('Product', productSchema);

module.exports = Product;