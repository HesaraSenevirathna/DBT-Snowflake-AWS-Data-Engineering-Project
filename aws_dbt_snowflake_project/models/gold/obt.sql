{% set congigs = [
    {
        "table": "AWS.SILVER.SILVER_BOOKINGS",
        "columns": "SILVER_bookings.*",
        "alias": "SILVER_bookings",
    },
    {
        "table": "AWS.SILVER.SILVER_LISTINGS",
        "columns": "SILVER_listings.HOST_ID, SILVER_listings.PROPERTY_TYPE, SILVER_listings.ROOM_TYPE, SILVER_listings.CITY, SILVER_listings.COUNTRY, SILVER_listings.ACCOMMODATES, SILVER_listings.BEDROOMS, SILVER_listings.BATHROOMS, SILVER_listings.PRICE_PER_NIGHT, silver_listings.PRICE_PER_NIGHT_TAG, SILVER_listings.CREATED_AT AS LISTING_CREATED_AT",
        "alias": "SILVER_listings",
        "join_condition": "SILVER_bookings.listing_id = SILVER_listings.listing_id",
    },
    {
        "table": "AWS.SILVER.SILVER_HOSTS",
        "columns": "SILVER_hosts.HOST_NAME, SILVER_hosts.HOST_SINCE, SILVER_hosts.IS_SUPERHOST, SILVER_hosts.RESPONSE_RATE, SILVER_hosts.RESPONSE_RATE_QUALITY, SILVER_hosts.CREATED_AT AS HOST_CREATED_AT",
        "alias": "SILVER_hosts",
        "join_condition": "SILVER_listings.host_id = SILVER_hosts.host_id",
    },
] %}

-- "alias" : "SILVER_hosts" tells dbt to create the model in the database using the
-- name SILVER_hosts instead of the default name derived from the SQL file.
-- If you want to add more new tables edit above config
select
    {% for config in congigs %}  -- This loops through each item in the configs list.
        {{ config["columns"] }}{% if not loop.last %},{% endif %}  -- {{ config['columns'] }} loops through each item in the configs list and {% if not loop.last %},{% endif %} adds a comma after each item except the last one.
    {% endfor %}
from
{% for config in congigs %}
        {% if loop.first %}  -- True only during the first iteration
            {{ config["table"] }} as {{ config["alias"] }}  -- The first table in the list is selected as the base table, other tables are joined to it.
    {% else %}
        left join
            {{ config["table"] }} as {{ config["alias"] }}  -- True for all iterations after the first
            on {{ config["join_condition"] }}
    {% endif %}
{% endfor %}
