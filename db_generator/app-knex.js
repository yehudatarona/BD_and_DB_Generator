const config = require("config");
const fs = require("fs");
const axios = require("axios");
const scale = config.get("scale");
const raw_repo = require("./raw-repo");

// // testing connection
// const getCountriers = async () => {
//   try {
//     const results = await raw_repo.getRawResult('select * from sp_get_all_countries()');
//     console.log("getting data for DB successed: ",results.rows);
//   } catch (err) {
//     console.log("received error: ", err.message);
//   }
// };
// getCountriers();


let now = new Date(); 
let isoDate = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toUTCString();
let isoDatePlus3hours = new Date((now.getTime())+(1000 * 60 *60 *48)- now.getTimezoneOffset() * 60000).toUTCString();
//OUTPUT 2021-08-25 20:23:00.000000


// empty all tables in BD
const emptyTablesAndResetDB = async () => {
    console.log("Delete and reset all tables...");
    try {
        const results = await raw_repo.getRawResult(`call sp_delete_and_reset_all();`);
        console.log("All tables in  had being reset: ", results.rows);
    } catch (err) {
        console.log("Delete all - received error: ", err.message);
    }
};

const countriesInsert = async () => {
    console.log("Countries insert... ");
    try {
        const response = await axios.get(`https://restcountries.eu/rest/v2/all`);
        for (let i = 0; i < response.data.length; i++) {
            try {
                let country_name = response.data[i].name;
                const result = await raw_repo.getRawResult(`select * from sp_insert_country('${country_name}');`);
                if (i == (response.data.length - 1)) {
                    console.log("Number of added items = ", result.rows[0].sp_insert_country, " countries");
                }
            } catch (err) {
                console.log(err.message);
            }
        };
        console.log("insert country name to countries table successed. ");
    } catch (err) {
        console.log(" Countries insert - received error: ", err.message);

    };
};


const usersCustomersInsert = async () => {
    console.log("Users insert... ");

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

            const userResult = await raw_repo.getRawResult(`select * from sp_insert_user('${username}', '${password}','${email}');`);
            if (i == (response.data.results.length - 1)) {
                console.log("Number of added items = ", userResult.rows[0].sp_insert_user, " users");
            };
            const customerResult = await raw_repo.getRawResult(`select * from sp_insert_customers('${first_name}', '${last_name}','${address}','${phone}','${credit_card}',${userResult.rows[0].sp_insert_user});`);
            if (i == (response.data.results.length - 1)) {
                console.log("Number of added items = ", customerResult.rows[0].sp_insert_customers, "customers");
            };
        };
        console.log("insert user/customer info to users/customers table successed. ");
    } catch (err) {

        console.log("user-customr insert - received error: ", err.message);
    }

};


const airlinesInsert = async () => {

    console.log("Inserting Airlines...");
    try {
        string_from_file = fs.readFileSync('./data/airlines.json', {
            encoding: 'utf8',
            flag: 'r'
        });
        let data = JSON.parse(string_from_file);
        for (let i = 0; i < scale.airlines; i++) {
            const airlinesResult = await raw_repo.getRawResult(`select * from sp_insert_airlines('${data[i].name}',${Math.floor(Math.random() * 246) + 1}, ${i + 1});`);
            if (i == scale.airlines - 1) {
                console.log("Number of added items = ", airlinesResult.rows[0].sp_insert_airlines, "airlines");
            };
        };
        console.log("insert airline info to airlines table successed. ");
    } catch (err) {
        console.log("airline insert - received error: ", err.message);
    }
};

const flightsInsert = async () => {
    console.log("inserting flights...");
    try {

        for (let i = 0; i < scale.airlines; i++) {
            let flightsResult;
            for (let j = 0; j < (Math.floor(Math.random() * scale.flights_per_airline) + 1); j++) {

                flightsResult = await raw_repo.getRawResult(`select * from sp_insert_flights(${i+1},${Math.floor(Math.random() * 246) + 1},${Math.floor(Math.random() * 247) + 1},'${isoDate}','${isoDatePlus3hours}',${Math.floor(Math.random() * 250)});`);
            }
            if (i == scale.airlines - 1) {
                console.log("Number of added items = ", flightsResult.rows[0].sp_insert_flights, "flights");
            };
        };
        console.log("insert flight info to flights table successed. ");
    } catch (err) {
        console.log("flight insert - received error: ", err.message);
    };
};

const ticketsInsert = async () => {
    console.log("inserting tickets...");
    try {
        for (let i = 0; i < scale.customers; i++) {
            const ticketsResult = await raw_repo.getRawResult(`select * from sp_insert_ticket('${i + 1}','${i + 1}');`);
            if (i == scale.customers - 1) {
                console.log("Number of added items = ", ticketsResult.rows[0].sp_insert_ticket, "tickets");
            };
        };
        console.log("insert ticke info to tickets table successed. ");
    } catch (err) {
        console.log("ticket insert - received error: ", err.message);

    };

};


const runAll = async () => {
    await emptyTablesAndResetDB();
    await countriesInsert();
    await usersCustomersInsert();
    await airlinesInsert();
    await flightsInsert();
    await ticketsInsert();
}

runAll();