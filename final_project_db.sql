--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sp_delete_airline_cascade(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airline_cascade(_airline_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from flights
        using airlines
        where flights.airline_id = _airline_id;

        with rows as  (
            delete from airlines
            where airlines.id = _airline_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_airline_cascade(_airline_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_airlines(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airlines(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from airlines
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_airlines(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_and_reset_airlines(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_airlines()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from airlines
        where id >= 1;
        alter sequence airlines_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_airlines() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_all(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_all()
    LANGUAGE plpgsql
    AS $$
    begin
		 call sp_delete_and_reset_tickets();
		 call sp_delete_and_reset_flights();
		 call sp_delete_and_reset_airlines();
		 call sp_delete_and_reset_customers();
		 call sp_delete_and_reset_countries();
		 call sp_delete_and_reset_users();
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_all() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_countries(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_countries()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from countries
        where id >= 1;
        alter sequence countries_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_countries() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_customers(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_customers()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from customers
        where id >= 1;
        alter sequence customers_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_customers() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_flights(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_flights()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from flights
        where id >= 1;
        alter sequence flights_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_flights() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_tickets(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_tickets()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from tickets
        where id >= 1;
        alter sequence tickets_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_tickets() OWNER TO postgres;

--
-- Name: sp_delete_and_reset_users(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_users()
    LANGUAGE plpgsql
    AS $$
    begin
        delete from users
        where id >= 1;
        alter sequence users_id_seq restart with 1;
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_users() OWNER TO postgres;

--
-- Name: sp_delete_countries(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_countries(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from countries
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_countries(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_country_cascade(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_country_cascade(_country_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete  from flights where flights.airline_id = (select id from airlines where airlines.country_id = _country_id);
        delete from airlines where airlines.country_id = _country_id;

        with rows as  (
            delete from countries
            where countries.id = _country_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_country_cascade(_country_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_customer_cascade(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customer_cascade(_customer_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from tickets
        using customers
        where tickets.customer_id = _customer_id;

        with rows as  (
            delete from customers
            where customers.id = _customer_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_customer_cascade(_customer_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_customers(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customers(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from customers
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_customers(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flight_cascade(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flight_cascade(_flight_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from tickets
        using flights
        where flights.id = _flight_id;

        with rows as  (
            delete from flights
            where flights.id = _flight_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_flight_cascade(_flight_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flights(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flights(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from flights
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_flights(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_tickets(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_tickets(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from tickets
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_tickets(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_user_cascade(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_user_cascade(_users_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from tickets where tickets.customer_id = (select customers.id from customers where customers.user_id = _users_id);
        delete from customers where customers.user_id = _users_id;
        delete from flights where flights.airline_id = (select airlines.id from airlines where airlines.user_id = _users_id );
        delete from airlines where airlines.user_id = _users_id;

        with rows as  (
            delete from users
            where users.id = _users_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_user_cascade(_users_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_users(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_users(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            rows_count int := 0;
        begin
            with rows as(
                delete  from users
                where id = _id
                returning 1)
            select  count(*) into rows_count from rows;
            return  rows_count;
        end;
    $$;


ALTER FUNCTION public.sp_delete_users(_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airlines (
    id bigint NOT NULL,
    name text NOT NULL,
    country_id bigint,
    user_id bigint
);


ALTER TABLE public.airlines OWNER TO postgres;

--
-- Name: sp_get_airlines_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_airlines_by_id(_id bigint) RETURNS SETOF public.airlines
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from airlines
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_airlines_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_all_airlines(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_airlines() RETURNS SETOF public.airlines
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from airlines;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_airlines() OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: sp_get_all_countries(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_countries() RETURNS SETOF public.countries
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from countries;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_countries() OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    address text NOT NULL,
    phone_no text NOT NULL,
    credit_card_no text NOT NULL,
    user_id bigint
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: sp_get_all_customers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_customers() RETURNS SETOF public.customers
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from customers;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_customers() OWNER TO postgres;

--
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    id bigint NOT NULL,
    airline_id bigint,
    origin_country_id bigint,
    destination_country_id bigint,
    departure_time timestamp without time zone,
    landing_time timestamp without time zone,
    remaining_tickets integer
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- Name: sp_get_all_flights(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_flights() RETURNS SETOF public.flights
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from flights;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_flights() OWNER TO postgres;

--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    id bigint NOT NULL,
    flight_id bigint,
    customer_id bigint
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: sp_get_all_tickets(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_tickets() RETURNS SETOF public.tickets
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from tickets;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_tickets() OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text,
    password text,
    email text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: sp_get_all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_users() RETURNS SETOF public.users
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from users;
    end;
    $$;


ALTER FUNCTION public.sp_get_all_users() OWNER TO postgres;

--
-- Name: sp_get_countries_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_countries_by_id(_id bigint) RETURNS SETOF public.countries
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from countries
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_countries_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_customers_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_customers_by_id(_id bigint) RETURNS SETOF public.customers
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from customers
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_customers_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_flights_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_flights_by_id(_id bigint) RETURNS SETOF public.flights
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from flights
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_flights_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_tickets_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_tickets_by_id(_id bigint) RETURNS SETOF public.tickets
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from tickets
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_tickets_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_users_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_users_by_id(_id bigint) RETURNS SETOF public.users
    LANGUAGE plpgsql
    AS $$
    begin
        return query
        select * from users
        where id = _id;
    end;
    $$;


ALTER FUNCTION public.sp_get_users_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_airlines(text, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_airlines(_name text, _country_id bigint, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        new_id bigint;
        begin
        insert into  airlines (name, country_id, user_id)
        values (_name, _country_id, _user_id)
        returning  id into new_id;
        return new_id;
        end;
    $$;


ALTER FUNCTION public.sp_insert_airlines(_name text, _country_id bigint, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_country(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_country(_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            new_id bigint;
        begin
            insert into countries (name)
            values (_name)
            returning id into new_id;

            return new_id;
        end ;
    $$;


ALTER FUNCTION public.sp_insert_country(_name text) OWNER TO postgres;

--
-- Name: sp_insert_customers(text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_customers(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        new_id bigint;
        begin
        insert into  customers (first_name, last_name, address, phone_no, credit_card_no, user_id)
        values (_first_name, _last_name, _address, _phone_no, _credit_card_no, _user_id)
        returning  id into new_id;
        return new_id;
        end;
    $$;


ALTER FUNCTION public.sp_insert_customers(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_flights(bigint, bigint, bigint, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_flights(_airline_id bigint, _origin_country_id bigint, _destination_country_id bigint, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        new_id bigint;
        begin
        insert into  flights (airline_id, origin_country_id, destination_country_id, departure_time, landing_time, remaining_tickets)
        values (_airline_id, _origin_country_id, _destination_country_id, _departure_time, _landing_time, _remaining_tickets)
        returning  id into new_id;
        return new_id;
        end;
    $$;


ALTER FUNCTION public.sp_insert_flights(_airline_id bigint, _origin_country_id bigint, _destination_country_id bigint, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_insert_ticket(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_ticket(_flight_id bigint, _customer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        new_id bigint;
        begin
        insert into  tickets (flight_id, customer_id)
        values (_flight_id, _customer_id)
        returning  id into new_id;
        return new_id;
        end;
    $$;


ALTER FUNCTION public.sp_insert_ticket(_flight_id bigint, _customer_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_user(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_user(_username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare
            new_id bigint;
        begin
            insert into users (username, password, email)
            values (_username, _password, _email)
            returning id into new_id;

            return new_id;
        end ;
    $$;


ALTER FUNCTION public.sp_insert_user(_username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_update_airlines(bigint, text, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_airlines(_id bigint, _name text, _country_id bigint, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        with rows as (
            update  airlines
            set name = _name, country_id = _country_id, user_id = _user_id
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_airlines(_id bigint, _name text, _country_id bigint, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_countries(bigint, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_countries(_id bigint, _name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int :=0;
    begin
        with rows as (
            update  countries
            set name = _name
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_countries(_id bigint, _name text) OWNER TO postgres;

--
-- Name: sp_update_customers(bigint, text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_customers(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        with rows as (
            update  customers
            set first_name = _first_name, last_name = _last_name, address = _address, phone_no = _phone_no, credit_card_no = _credit_card_no , user_id = _user_id
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_customers(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_flights(bigint, bigint, bigint, bigint, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id bigint, _destination_country_id bigint, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        with rows as (
            update  flights
            set airline_id = _airline_id, origin_country_id = _origin_country_id, destination_country_id = _destination_country_id,
                departure_time = _departure_time, landing_time = _landing_time, remaining_tickets = _remaining_tickets
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id bigint, _destination_country_id bigint, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_update_tickets(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_tickets(_id bigint, _flight_id bigint, _customer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int :=0;
    begin
        with rows as (
            update  tickets
            set flight_id = _flight_id, customer_id = _customer_id
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_tickets(_id bigint, _flight_id bigint, _customer_id bigint) OWNER TO postgres;

--
-- Name: sp_update_users(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_users(_id bigint, _username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int :=0;
    begin
        with rows as (
            update  users
            set username = _username, password = _password, email = _email
            where id = _id
            returning 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_update_users(_id bigint, _username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_upsert_users(text, text, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_upsert_users(_username text, _password text, _email text, _upsert text)
    LANGUAGE plpgsql
    AS $$
    declare
        new_id bigint;
    begin
        insert into users(username, password, email)
        values (_username, _password, _email)
         on conflict (username)
            do update
            set username = _username, password = _password, email = _upsert;
--         returning id into new_id;
--         return new_id;
    end;
    $$;


ALTER PROCEDURE public.sp_upsert_users(_username text, _password text, _email text, _upsert text) OWNER TO postgres;

--
-- Name: airlines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.airlines_id_seq OWNER TO postgres;

--
-- Name: airlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airlines_id_seq OWNED BY public.airlines.id;


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: flights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flights_id_seq OWNER TO postgres;

--
-- Name: flights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flights_id_seq OWNED BY public.flights.id;


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tickets_id_seq OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: airlines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines ALTER COLUMN id SET DEFAULT nextval('public.airlines_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: flights id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights ALTER COLUMN id SET DEFAULT nextval('public.flights_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: airlines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airlines (id, name, country_id, user_id) FROM stdin;
1	Private flight	100	1
2	135 Airways	15	2
3	1Time Airline	78	3
4	2 Sqn No 1 Elementary Flying Training School	229	4
5	213 Flight Unit	224	5
6	223 Flight Unit State Airline	9	6
7	224th Flight Unit	89	7
8	247 Jet Ltd	40	8
9	3D Aviation	226	9
10	40-Mile Air	4	10
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name) FROM stdin;
1	Afghanistan
2	Åland Islands
3	Albania
4	Algeria
5	American Samoa
6	Andorra
7	Angola
8	Anguilla
9	Antarctica
10	Antigua and Barbuda
11	Argentina
12	Armenia
13	Aruba
14	Australia
15	Austria
16	Azerbaijan
17	Bahamas
18	Bahrain
19	Bangladesh
20	Barbados
21	Belarus
22	Belgium
23	Belize
24	Benin
25	Bermuda
26	Bhutan
27	Bolivia (Plurinational State of)
28	Bonaire, Sint Eustatius and Saba
29	Bosnia and Herzegovina
30	Botswana
31	Bouvet Island
32	Brazil
33	British Indian Ocean Territory
34	United States Minor Outlying Islands
35	Virgin Islands (British)
36	Virgin Islands (U.S.)
37	Brunei Darussalam
38	Bulgaria
39	Burkina Faso
40	Burundi
41	Cambodia
42	Cameroon
43	Canada
44	Cabo Verde
45	Cayman Islands
46	Central African Republic
47	Chad
48	Chile
49	China
50	Christmas Island
51	Cocos (Keeling) Islands
52	Colombia
53	Comoros
54	Congo
55	Congo (Democratic Republic of the)
56	Cook Islands
57	Costa Rica
58	Croatia
59	Cuba
60	Curaçao
61	Cyprus
62	Czech Republic
63	Denmark
64	Djibouti
65	Dominica
66	Dominican Republic
67	Ecuador
68	Egypt
69	El Salvador
70	Equatorial Guinea
71	Eritrea
72	Estonia
73	Ethiopia
74	Falkland Islands (Malvinas)
75	Faroe Islands
76	Fiji
77	Finland
78	France
79	French Guiana
80	French Polynesia
81	French Southern Territories
82	Gabon
83	Gambia
84	Georgia
85	Germany
86	Ghana
87	Gibraltar
88	Greece
89	Greenland
90	Grenada
91	Guadeloupe
92	Guam
93	Guatemala
94	Guernsey
95	Guinea
96	Guinea-Bissau
97	Guyana
98	Haiti
99	Heard Island and McDonald Islands
100	Holy See
101	Honduras
102	Hong Kong
103	Hungary
104	Iceland
105	India
106	Indonesia
107	Iran (Islamic Republic of)
108	Iraq
109	Israel
110	Italy
164	Northern Mariana Islands
165	Norway
166	Oman
167	Pakistan
168	Palau
169	Palestine, State of
170	Panama
171	Papua New Guinea
172	Paraguay
173	Peru
174	Philippines
175	Pitcairn
176	Poland
177	Portugal
178	Puerto Rico
179	Qatar
180	Republic of Kosovo
181	Réunion
182	Romania
183	Russian Federation
184	Rwanda
185	Saint Barthélemy
186	Saint Helena, Ascension and Tristan da Cunha
187	Saint Kitts and Nevis
188	Saint Lucia
189	Saint Martin (French part)
190	Saint Pierre and Miquelon
191	Saint Vincent and the Grenadines
192	Samoa
193	San Marino
194	Sao Tome and Principe
195	Saudi Arabia
196	Senegal
197	Serbia
198	Seychelles
199	Sierra Leone
200	Singapore
201	Sint Maarten (Dutch part)
202	Slovakia
203	Slovenia
204	Solomon Islands
205	Somalia
206	South Africa
207	South Georgia and the South Sandwich Islands
208	Korea (Republic of)
209	South Sudan
210	Spain
211	Sri Lanka
212	Sudan
213	Suriname
214	Svalbard and Jan Mayen
215	Swaziland
216	Sweden
217	Switzerland
218	Syrian Arab Republic
219	Taiwan
220	Tajikistan
221	Tanzania, United Republic of
222	Thailand
223	Timor-Leste
224	Togo
225	Tokelau
226	Tonga
227	Trinidad and Tobago
228	Tunisia
229	Turkey
230	Turkmenistan
231	Turks and Caicos Islands
232	Tuvalu
233	Uganda
234	Ukraine
235	United Arab Emirates
236	United Kingdom of Great Britain and Northern Ireland
237	United States of America
238	Uruguay
239	Uzbekistan
240	Vanuatu
241	Venezuela (Bolivarian Republic of)
242	Viet Nam
243	Wallis and Futuna
244	Western Sahara
245	Yemen
246	Zambia
247	Zimbabwe
111	Isle of Man
112	Jamaica
113	Japan
114	Jersey
115	Jordan
122	Latvia
123	Lebanon
124	Lesotho
125	Liberia
126	Libya
127	Liechtenstein
128	Lithuania
129	Luxembourg
130	Macao
131	Macedonia (the former Yugoslav Republic of)
132	Madagascar
133	Malawi
134	Malaysia
135	Maldives
136	Mali
137	Malta
138	Marshall Islands
139	Martinique
140	Mauritania
141	Mauritius
142	Mayotte
143	Mexico
144	Micronesia (Federated States of)
145	Moldova (Republic of)
146	Monaco
147	Mongolia
148	Montenegro
149	Montserrat
150	Morocco
151	Mozambique
152	Myanmar
153	Namibia
154	Nauru
155	Nepal
156	Netherlands
157	New Caledonia
158	New Zealand
159	Nicaragua
160	Niger
161	Nigeria
162	Niue
163	Norfolk Island
116	Ireland
117	Kazakhstan
118	Kenya
119	Kiribati
120	Kuwait
121	Kyrgyzstan
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, first_name, last_name, address, phone_no, credit_card_no, user_id) FROM stdin;
1	Mads	Poulsen	Aarhus N, Midtjylland, Denmark	05600123	8c637061-cf93-4dad-bf91-9e4908b01336	1
2	Lucy	Menard	Fort-de-France, Haute-Marne, France	05-41-35-85-55	01fb201a-067f-4aa6-baf5-6bbc19fea222	2
3	Sofia	Petersen	Hammel, Nordjylland, Denmark	48431783	a19f7259-d988-4097-bcef-1cea87f69ea4	3
4	Beatrice	Wilson	Sherbrooke, Nunavut, Canada	437-232-7680	cf60f49b-cd3f-435f-aff6-6a377d642bd5	4
5	Roger	Murray	Bundaberg, New South Wales, Australia	04-4711-0332	840d8d0f-632a-43f6-973b-93c3297ee5e2	5
6	Chris	Brewer	Drogheda, Waterford, Ireland	021-060-2780	faf76c45-4c9e-40e4-84e2-1317710b7a06	6
7	Leonardo	Eldevik	Rød, Oslo, Norway	38118467	a823390c-ca46-413c-9fd7-6967b2205549	7
8	Jacques	Rodriguez	Stalden (Vs), Appenzell Innerrhoden, Switzerland	076 945 36 60	6af4e640-e2f9-4de1-9621-09f5e3060c5a	8
9	Malthe	Møller	Nykøbing Sj., Syddanmark, Denmark	56191691	7a8bdfa3-0a13-4bd0-9863-56a998060cd4	9
10	Alexandra	Phillips	Athenry, Kerry, Ireland	061-986-8542	f6da90a3-6166-455d-812f-032e33d69bac	10
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (id, airline_id, origin_country_id, destination_country_id, departure_time, landing_time, remaining_tickets) FROM stdin;
1	1	232	2	2021-10-14 11:20:10	2021-10-21 11:20:10	100
2	1	79	197	2021-10-14 11:20:10	2021-10-21 11:20:10	12
3	2	12	129	2021-10-14 11:20:10	2021-10-21 11:20:10	38
4	3	38	59	2021-10-14 11:20:10	2021-10-21 11:20:10	76
5	3	39	80	2021-10-14 11:20:10	2021-10-21 11:20:10	189
6	4	225	163	2021-10-14 11:20:10	2021-10-21 11:20:10	147
7	5	179	153	2021-10-14 11:20:10	2021-10-21 11:20:10	191
8	5	233	164	2021-10-14 11:20:10	2021-10-21 11:20:10	42
9	6	32	120	2021-10-14 11:20:10	2021-10-21 11:20:10	61
10	7	84	151	2021-10-14 11:20:10	2021-10-21 11:20:10	176
11	8	95	72	2021-10-14 11:20:10	2021-10-21 11:20:10	224
12	8	26	132	2021-10-14 11:20:10	2021-10-21 11:20:10	23
13	8	28	176	2021-10-14 11:20:10	2021-10-21 11:20:10	187
14	9	151	57	2021-10-14 11:20:10	2021-10-21 11:20:10	63
15	9	68	97	2021-10-14 11:20:10	2021-10-21 11:20:10	44
16	10	87	208	2021-10-14 11:20:10	2021-10-21 11:20:10	97
17	10	2	110	2021-10-14 11:20:10	2021-10-21 11:20:10	98
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (id, flight_id, customer_id) FROM stdin;
1	1	1
2	2	2
3	3	3
4	4	4
5	5	5
6	6	6
7	7	7
8	8	8
9	9	9
10	10	10
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email) FROM stdin;
1	organicbutterfly627	wage	mads.poulsen@example.com
2	blueelephant935	bryan	lucy.menard@example.com
3	whitegorilla449	volcom	sofia.petersen@example.com
4	bluefish543	testing	beatrice.wilson@example.com
5	goldenzebra874	script	roger.murray@example.com
6	redlion762	jenny	chris.brewer@example.com
7	smallbutterfly250	stayout	leonardo.eldevik@example.com
8	goldenkoala638	jeremiah	jacques.rodriguez@example.com
9	redostrich174	dwayne	malthe.moller@example.com
10	tinykoala317	deanna	alexandra.phillips@example.com
\.


--
-- Name: airlines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airlines_id_seq', 10, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 247, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 10, true);


--
-- Name: flights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_id_seq', 17, true);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 10, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: airlines airlines_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pk PRIMARY KEY (id);


--
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id);


--
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- Name: flights flights_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pk PRIMARY KEY (id);


--
-- Name: tickets tickets_flight_id_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_customer_id_key UNIQUE (flight_id, customer_id);


--
-- Name: tickets tickets_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pk PRIMARY KEY (id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: airlines_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX airlines_id_uindex ON public.airlines USING btree (id);


--
-- Name: airlines_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX airlines_name_uindex ON public.airlines USING btree (name);


--
-- Name: airlines_user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX airlines_user_id_uindex ON public.airlines USING btree (user_id);


--
-- Name: countries_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX countries_id_uindex ON public.countries USING btree (id);


--
-- Name: countries_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX countries_name_uindex ON public.countries USING btree (name);


--
-- Name: customers_credit_card_no_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_credit_card_no_uindex ON public.customers USING btree (credit_card_no);


--
-- Name: customers_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_id_uindex ON public.customers USING btree (id);


--
-- Name: customers_phone_no_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_phone_no_uindex ON public.customers USING btree (phone_no);


--
-- Name: customers_user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_user_id_uindex ON public.customers USING btree (user_id);


--
-- Name: flights_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX flights_id_uindex ON public.flights USING btree (id);


--
-- Name: tickets_customer_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tickets_customer_id_uindex ON public.tickets USING btree (customer_id);


--
-- Name: tickets_flight_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tickets_flight_id_uindex ON public.tickets USING btree (flight_id);


--
-- Name: tickets_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tickets_id_uindex ON public.tickets USING btree (id);


--
-- Name: users_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_uindex ON public.users USING btree (email);


--
-- Name: users_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_id_uindex ON public.users USING btree (id);


--
-- Name: users_username_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_uindex ON public.users USING btree (username);


--
-- Name: airlines airlines_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_country_id_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: airlines airlines_user_id__fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_user_id__fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: customers customers_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: flights flights_airline_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_airline_id_fk FOREIGN KEY (airline_id) REFERENCES public.airlines(id);


--
-- Name: flights flights_destination_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_destination_country_id_fk FOREIGN KEY (destination_country_id) REFERENCES public.countries(id);


--
-- Name: flights flights_origin_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_origin_country_id_fk FOREIGN KEY (origin_country_id) REFERENCES public.countries(id);


--
-- Name: tickets tickets_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_customer_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: tickets tickets_flight_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_fk FOREIGN KEY (flight_id) REFERENCES public.flights(id);


--
-- PostgreSQL database dump complete
--

