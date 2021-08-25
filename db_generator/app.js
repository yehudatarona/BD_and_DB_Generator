const config = require('config');
const fs = require("fs")
const Pool = require('pg').Pool
const axios = require('axios')

const db_connect = config.get('db');

const scale = config.get('scale');

const ranDate = require('./date_generate');

const results = ranDate();

console.log("rrrrr",results.departure_time);

// console.log(db_connect);
// console.log(scale);


// connect to db
const pool = new Pool({
    user: db_connect.user,
    host: db_connect.host,
    database: db_connect.database,
    password: db_connect.password,
    port: db_connect.port,

})

const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay));
const randomDate = () => {
    // 2021-10-14 11:20:10.000000
    return `2021-${Math.floor(Math.random() * 12) + 1}-${Math.floor(Math.random() * 28) + 1}00:00:00.000000`;

}

// empty all tables in BD
const emptyTablesAndResetDB = async () => {
    console.log("All tables in  had being reset")

    await pool.query('call sp_delete_and_reset_all();', (err) => {
        if (err)
            console.log(`error: ${err}`)
        console.log(`DB was rested`);
    });
}

///insert countries name to countries table using api with axios///
const countriesInsert = async () => {
console.log("Countries insert... ");

    try {
        const response = await axios.get(`https://restcountries.eu/rest/v2/all`);
        
        for (let i = 0; i < response.data.length; i++) {
            //console.log(response.data[i].name);
            
            response.data[i].name = response.data[i].name.replace(/[\uE000-\uF8FF]/g, '');
            query = `select * from sp_insert_country('${response.data[i].name}');`
            await sleep(20)
            await pool.query(query, (err, res) => {
                if (err) {
                    console.log(err.message)
                } else {
                    console.log("country: " + res.rows[0].sp_insert_country)
                }
            });

        };
    }
    catch (err) {
        console.log("received error: ", err.message);

    };
    await sleep(500)
};

const usersCustomersInsert = async () => {
   
    try {
        const response = await axios.get(`https://randomuser.me/api/?results=${scale.customers}&seed=bbb`);
        for (let i = 0; i < response.data.results.length; i++) {

            let first_name = response.data.results[i].name.first;
            let last_name = response.data.results[i].name.last;
            let username = response.data.results[i].login.username;
            let password = response.data.results[i].login.password;
            let email = response.data.results[i].email;
            let phone = response.data.results[i].phone;
            let address = response.data.results[i].location.city + ", " + response.data.results[i].location.state + ", " + response.data.results[i].location.country;
            let credit_card = response.data.results[i].login.uuid;
            await sleep(20)
            await pool.query(`select * from sp_insert_user('${username}', '${password}','${email}');`, (err, res) => {
                if (err){
                    console.log(err);
                    // return err;
                    
                } 
                else console.log("user: " + res.rows[0].sp_insert_user);
            });
            await sleep(20)
            await pool.query(`select * from sp_insert_customers('${first_name}', '${last_name}','${address}','${phone}','${credit_card}',${i+1});`, (err, res) => {
                if (err) console.log(err);
                else console.log("customer: " + res.rows[0].sp_insert_customers);
            }); 

        };
    }
    catch (err) {

        console.log("received error: ", err.message);
    }
    await sleep(500)
}




const airlinesInsert = async () => {

    console.log("Inserting Airlines...");
    try{
        string_from_file = fs.readFileSync('./data/airlines.json', { encoding: 'utf8', flag: 'r' });
        let data = JSON.parse(string_from_file);
        for (let i = 0; i < scale.airlines; i++) {
            await sleep(20)
            await pool.query(`select * from sp_insert_airlines('${data[i].name}',${Math.floor(Math.random() * 246) + 1}, ${i + 1});`, (err, res) => {
                if (err)
                    console.log(`Error during airline ${i} insert: ${err}`);
                else
                    console.log("ariline: " + res.rows[0].sp_insert_airlines);
            });
        }
        
    }
    catch(err){
        console.log("received error: ", err.message);
    }
   
    await sleep(500)
}

const flightsInsert =  async ()=>{
    console.log("inserting flights...");
    try{
        
        for (let i=0; i< scale.airlines; i++) {
            for (let j = 0; j < (Math.floor(Math.random() * scale.flights_per_airline) + 1); j++) {
                await sleep(20);
                await pool.query(`select * from sp_insert_flights(${i+1},${Math.floor(Math.random() * 246) + 1},${Math.floor(Math.random() * 246) + 1},'2021-10-14 11:20:10','2021-10-21 11:20:10',${Math.floor(Math.random() * 250)});`,(err, res)=>{ 
                if (err) console.log(err);
                else console.log("flight: " + res.rows[0].sp_insert_flights);
                })   
            }   
        }

    }
    catch(err){
        console.log("received error: ", err.message);
    }
    await sleep(500);
}

const  ticketsInsert = async ()=>{
    console.log("inserting tickets...");
    try{
        for (let i = 0; i < scale.customers; i++) {
            await sleep(20);
            await pool.query(`select * from sp_insert_ticket('${i + 1}','${i + 1}')`, (err, res) => {
                if (err) console.log(err);
                else console.log("tickets: " + res.rows[0].sp_insert_ticket);
            });
        }
    }
    catch(err){
        console.log("received error: ", err.message);

    }
    await sleep(500);
}
const runAll = async () => {
    await emptyTablesAndResetDB();
    await countriesInsert();
    await usersCustomersInsert();
    await airlinesInsert(); 
    await flightsInsert();
    await ticketsInsert();
}

runAll();
console.log('end of program');

