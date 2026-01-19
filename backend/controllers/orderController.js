const mongoose = require('mongoose');
const Order = require('../models/order');
const ShoppingCart = require('../models/shopping_cart');
const Client = require('../models/client');
const OrderStatus = require('../enum/orderStatus');

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
        const shopId = normalizeId(req.body.shopId);
        const { products, address, paymentMethod, totalPrice } = req.body;

        if (!clientId || !shopId) {
            return res.status(400).json({ error: 'Missing clientId or shopId' });
        }

        const client = await Client.findById(clientId);
        if (!client) return res.status(404).json({ error: 'Client not found' });

        const order = new Order({
            client: client._id,
            shop: shopId,
            products: products,
            address: address,
            paymentMethod: paymentMethod,
            totalPrice: totalPrice,
            status: OrderStatus.PENDING
        });

        await order.save();
        res.status(201).json(order);
    } catch (err) {
        next(err);
    }
};

async function getOrdersByShop(req, res, next) {
    try {
        const { shopId } = req.params;
        const orders = await Order.find({ shop: shopId })
            .populate({
                path: 'client',
                populate: { path: 'user', select: 'name email' } // bringing name and email
            })
            .sort({ createdAt: -1 })
            .exec();
        res.json(orders);
    } catch (err) {
        next(err);
    }
};

async function updateOrderStatus(req, res, next) {
    try {
        const { orderId } = req.params;
        const { status } = req.body;

        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ error: 'Order not found' });

        order.status = status;
        await order.save();
        res.json(order);
    } catch (err) {
        next(err);
    }
};

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
  getOrdersByShop,
  updateOrderStatus,
  getAllOrders,
};

