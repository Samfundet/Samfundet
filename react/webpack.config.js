const path = require('path');

module.exports = {
  entry: {
    sulten: "./sulten"
  },
  output: {
    filename: '../public/assets/[name].js',
    path: path.resolve(__dirname)
  },
  module: {
     loaders: [
       {
         test: /.js[x]?$/,
         loader: 'babel-loader',
         exclude: /node_modules/,
         include: __dirname,
         query: {
           presets: ['react', 'env']
         }
       },
       { test: /\.css$/,
         loader: "style-loader!css-loader"
       }
     ]
   },
};
