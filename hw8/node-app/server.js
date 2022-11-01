const express = require('express');
const cors = require("cors");
const config = require('./config.json');
const axios = require('axios');


const app = express();
app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
    res.send("Hello World!");
});
var headers = {
    'Authorization': `Bearer ${config.YELP_API_KEY}` 
};
app.get('/yelp/search', async (req, res) => {
    // console.log(req.query);
    const { keyword, latitude, longitude, categories, radius } = req.query;
    //    console.log(keyword);
    //    console.log(latitude);
    //    console.log(longitude);
    var rad = parseInt(parseFloat(radius) * 1609.344);
    const url = `https://api.yelp.com/v3/businesses/search?term=${keyword}&latitude=${latitude}&longitude=${longitude}&categories=${categories}&radius=${rad}`;
    const data = await axios.get(url, {
        mode: 'cors',
        headers: headers
    })
        .then(response => {
            return response.data;
        })
    return res.json(data);
});
app.get('/yelp/business', async (req,res) => {
    const {business_id} = req.query;
    // console.log(business_id);
    const url = `https://api.yelp.com/v3/businesses/${business_id}`;
    
    const data = await axios.get( url, {
        mode: 'cors',
        headers: headers
    })
        .then(response => {
            return response.data;
        })

    return res.json(data);
});

app.get('/yelp/autocomplete', async(req,res) => {
    const {text} = req.query;
    const url = `https://api.yelp.com/v3/autocomplete?text=${text}`;
    const data = await axios.get( url, {
        mode: 'cors',
        headers: headers
    })
        .then(response => {
            return response.data;
        })
    var results = [];
    for (const item of data["categories"]) {
        let temp = {}
        temp['text'] = item['title']
        results.push(temp);
    }
    for (const item of data["terms"]) {
        // let temp = {}
        // temp['text'] = item['text']
        results.push(item);
    }
    var output = {"suggestions": results};
    return res.json(output);
})

app.get('/yelp/reviews', async (req,res) => {
    const {business_id} = req.query;
    const url = `https://api.yelp.com/v3/businesses/${business_id}/reviews`;
    const data = await axios.get( url, {
        mode: 'cors',
        headers: headers
    })
        .then(response => {
            return response.data;
        });
    var results = [];
    for (const item of data['reviews']){
       let temp = {};
       temp['rating'] = item['rating'];
       temp['user_name'] = item['user']['name'];
       temp['text'] = item['text'];
       temp['time_created'] = item['time_created'];
       results.push(temp);
    }
    const output = {"reviews": results};
    return res.json(output);
})
const PORT = 8080;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});