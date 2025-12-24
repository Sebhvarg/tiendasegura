const List = require('../models/list');
const Product = require('../models/product');

async function getList(req, res, next) {
  try {
    const lists = await List.find().exec();

    const updatedLists = await Promise.all(
      lists.map(async (list) => {
        const products = await Product.find({
          _id: { $in: list.products }
        });

        const totalPrice = products.reduce(
          (sum, product) => sum + product.price,
          0
        );

        // 🔹 Actualiza y guarda en Mongo
        list.price = Number(totalPrice.toFixed(2));
        await list.save();

        return list;
      })
    );

    res.json(updatedLists);
  } catch (err) {
    next(err);
  }
}

module.exports = {
  getList
};
