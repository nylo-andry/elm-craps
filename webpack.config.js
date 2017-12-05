const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './src/index.js',

  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'app.[hash].js'
  },

  resolve: {
    alias: {
      '@elm': path.resolve(__dirname, 'src/elm'),
      '@scss': path.resolve(__dirname, 'src/scss')
    },
    extensions: ['.js', '.elm', '.scss']
  },

  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
        loader: 'elm-webpack-loader',
        options: {}
      }
    },
    {
      test: /\.scss$/,
      use: [{
        loader: 'style-loader'
      }, 
      {
        loader: 'css-loader'
      }, 
      {
        loader: 'sass-loader',
      }]
    }]
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({
      template: 'src/public/index.html',
    }),
    new CopyWebpackPlugin([
      { from: 'src/assets', to: 'assets' },
    ]),
  ],

  devServer: {
    hot: true,
    inline: true,
    stats: 'errors-only',
    port: 3000
  }
};