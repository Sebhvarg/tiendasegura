const mongoose = require('mongoose');
const Product = require('../models/product');

async function searchProducts(req, res, next) {
    try {
        const { query } = req.query;
        if (!query || query.trim() === '') {
            return res.status(400).json({ error: 'Query parameter is required' });
        }
        const regex = new RegExp(query, 'i'); // case-insensitive search
        const products = await Product.find({
            $or: [
                { name: regex },
                { description: regex },
                { category: regex }
            ]
        }).exec();
        res.json(products);
    } catch (err) {
        next(err);
    }
}

module.exports = {
    searchProducts,
};