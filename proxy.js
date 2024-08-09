const express =  require('express');
const cors  = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

app.use(cors()); // 启用所有来源的CORS请求

app.use('/api', createProxyMiddleware({
    target: 'https://cdn2.thedogapi.com',
    changeOrigin: true,
    pathRewrite:{
        '^/api':''
    },
    onProxyRes: (proxyRes)=>{
        proxyRes.headers['Access-Control-Allow-Origin'] = '*'; // 添加CORS头
    }
}))

app.listen(3000,()=>{
    console.log('server is running at port 3000')
})