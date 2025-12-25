const mongoose = require('mongoose');

const { Schema, model, Types } = mongoose;

const shopOwnerSchema = new Schema(
    {
        user: { type: Types.ObjectId, ref: 'User', required: true },
        shops : [{ type: Types.ObjectId, ref: 'Shop' }, { default: [] }],
        
    },
    { timestamps: true, collection: 'shop_owners' }
);
const ShopOwner = model('ShopOwner', shopOwnerSchema);
module.exports = ShopOwner;