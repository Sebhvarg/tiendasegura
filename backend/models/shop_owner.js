const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const shopOwnerSchema = new Schema(
    {
        name: { type: String, required: true, trim: true },
        email: { type: String, required: true, trim: true, unique: true },
        phone: { type: String, trim: true, default: '' },
        address: { type: String, trim: true, default: '' },
        isActive: { type: Boolean, default: true },
        shops : [{ type: Types.ObjectId, ref: 'Shop' }, { default: [] }],
        
    },
    { timestamps: true, collection: 'shop_owners' }
);
const ShopOwner = model('ShopOwner', shopOwnerSchema);
module.exports = ShopOwner;