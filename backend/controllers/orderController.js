const mongoose = require('mongoose');
const Order = require('../models/order');
const ShoppingCart = require('../models/shopping_cart');
const Client = require('../models/client');

async function getAllOrders(req, res, next) {
    try {
        const orders = await Order.find().exec();
        res.json(orders);
    } catch (err) {
        next(err);
    }   
};

// Helper to normalize IDs that may come as {_id}, {$oid}, JSON strings, or raw
function normalizeId(value) {
    if (value === undefined || value === null) return null;

    // If it's already an ObjectId-like object
    if (typeof value === 'object') {
        if (value._id) return String(value._id).trim();
        if (value.$oid) return String(value.$oid).trim();
    }

    let str = String(value).trim();

    // If comes as "{ \"$oid\": \"...\" }" try to parse JSON
    if ((str.startsWith('{') && str.endsWith('}')) || (str.startsWith('"{') && str.endsWith('}"'))) {
        try {
            const parsed = JSON.parse(str);
            if (parsed.$oid) return String(parsed.$oid).trim();
            if (parsed._id) return String(parsed._id).trim();
        } catch (_) {
            // fall through
        }
    }

    // Extract from patterns like ObjectId("..."), or if includes quotes
    const match = str.match(/([0-9a-fA-F]{24})/);
    if (match && match[1]) return match[1];

    return str;
}

async function createOrder(req, res, next) {
    try {
        const clientId = normalizeId(req.body.clientId);
        const shoppingCartId = normalizeId(req.body.shoppingCartId);

        if (!clientId || !mongoose.Types.ObjectId.isValid(clientId)) {
            return res.status(400).json({ error: 'Invalid clientId' });
        }
        if (!shoppingCartId || !mongoose.Types.ObjectId.isValid(shoppingCartId)) {
            return res.status(400).json({ error: 'Invalid shoppingCartId' });
        }

        const client = await Client.findById(clientId);
        if (!client) return res.status(404).json({ error: 'Client not found' });

        const shoppingCart = await ShoppingCart.findById(shoppingCartId);
        if (!shoppingCart) return res.status(404).json({ error: 'Shopping Cart not found' });
        const order = new Order({
            client: client._id,
            shoppingCart: shoppingCart._id,
        });
        await order.save();
        res.status(201).json(order);
    } catch (err) {
        next(err);
    }
};

// get order by client id (optional)

async function getOrdersByClient(req, res, next) {
    try {
        const { clientId } = req.params;
        const orders = await Order.find({ client: clientId }).exec();
        res.json(orders);
    } catch (err) {
        next(err);
    }
};

module.exports = {
  createOrder,
  getOrdersByClient,
    getAllOrders,
};

