node_dir = __dirname + '/node_modules'

webpack = require 'webpack'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
autoprefixer = require 'autoprefixer-stylus'
path = require 'path'

module.exports =

	entry:
		app: [__dirname + '/src/app.coffee']


	output:
		path: __dirname + '/build'
		path: path.resolve __dirname, "build"
		publicPath: '/build/'
		contentBase: '/'
		filename: 'build.js'

	devtool: 'source-map'

	module: loaders: [
		{
			# Exposes jQuery and $ to the window object. This does not automatically load the jquery module.
			test: /jquery\.js$/
			loader: "expose?jQuery!expose?$"
		}
		{
			test: /\.html$/
			loader: 'html'
		}
		{
			test:/\.haml$/
			loader: "haml"
		}
		{
			test: /\.styl$/
			loader: ExtractTextPlugin.extract 'style-loader', 'css?sourceMap!stylus-loader?sourceMap'
		}
		{
			test: /\.(png|woff|woff2|eot|ttf|svg)($|\?)/
			loader: 'url-loader?limit=100000'
		}
		{
			test: /\.coffee$/
			loader: "coffee-loader?bare"
		}
	]

	resolve:
		modulesDirectories: [
			'stylus',
			'node_modules'
		]

		alias:
			'jquery': node_dir + '/jquery/dist/jquery.js'
			'lodash': node_dir + '/lodash/index.js'

	plugins: [
		new webpack.OldWatchingPlugin,

		new webpack.ProvidePlugin
			_: 'lodash'
			$: "jquery"
			jQuery: "jquery"
			"window.jQuery": "jquery"
			"root.jQuery": "jquery"

		new ExtractTextPlugin 'style.css', { allChunks: true }
	]

	stylus: use: [autoprefixer()]
