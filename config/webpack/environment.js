const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const webpack = require('webpack')
const vue = require('./loaders/vue')
const path = require('path')


environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

// Add an ProvidePlugin
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    JQuery: 'jquery',
    jquery: 'jquery',
  }),
  new webpack.DefinePlugin({
    'process.env': require('./config/dev.env')
  })
)

const config = environment.toWebpackConfig()

environment.config.merge({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, '..', '..', 'app/javascript'),
      'vue$': 'vue/dist/vue.esm.js',
      jquery: "jquery/src/jquery",
    }
  }
})

module.exports = environment
