defmodule SnowplowTracker.Constants do
  @moduledoc """
  This module contains the constants used to construct the event payload and send
  them to the collector.

  ## Examples

      iex> SnowplowTracker.Constants.tracker_version()
      "elixir-0.1.0"
  """
  @tracker_version "elixir-0.1.0"
  @post_protocol_vendor "com.snowplowanalytics.snowplow"
  @post_protocol_version "tp2"
  @post_content_type "application/json; charset=utf-8"
  @post_wrapper_bytes 88
  @post_stm_bytes 22
  @get_protocol_path "i"
  @schema_payload_data "iglu:com.snowplowanalytics.snowplow/payload_data/jsonschema/1-0-4"
  @schema_contexts "iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-1"
  @schema_unstruct_event "iglu:com.snowplowanalytics.snowplow/unstruct_event/jsonschema/1-0-0"
  @schema_screen_view "iglu:com.snowplowanalytics.snowplow/screen_view/jsonschema/1-0-0"
  @schema_user_timings "iglu:com.snowplowanalytics.snowplow/timing/jsonschema/1-0-0"
  @event_page_view "pv"
  @event_structured "se"
  @event_unstructured "ue"
  @event_ecomm "tr"
  @event_ecomm_item "ti"
  @schema "schema"
  @data "data"
  @event "e"
  @eid "eid"
  @timestamp "dtm"
  @sent_timestamp "stm"
  @true_timestamp "ttm"
  @t_version "tv"
  @app_id "aid"
  @namespace "tna"
  @platform "p"
  @context "co"
  @context_encoded "cx"
  @unstructured "ue_pr"
  @unstructured_encoded "ue_px"
  @uid "uid"
  @resolution "res"
  @viewport "vp"
  @color_depth "cd"
  @timezone "tz"
  @language "lang"
  @ip_address "ip"
  @useragent "ua"
  @domain_uid "duid"
  @network_uid "tnuid"
  @page_url "url"
  @page_title "page"
  @page_refr "refr"
  @se_category "se_ca"
  @se_action "se_ac"
  @se_label "se_la"
  @se_property "se_pr"
  @se_value "se_va"
  @tr_id "tr_id"
  @tr_total "tr_tt"
  @tr_affiliation "tr_af"
  @tr_tax "tr_tx"
  @tr_shipping "tr_sh"
  @tr_city "tr_ci"
  @tr_state "tr_st"
  @tr_country "tr_co"
  @tr_currency "tr_cu"
  @ti_item_id "ti_id"
  @ti_item_sku "ti_sk"
  @ti_item_name "ti_nm"
  @ti_item_category "ti_ca"
  @ti_item_price "ti_pr"
  @ti_item_quantity "ti_qu"
  @ti_item_currency "ti_cu"
  @sv_id "id"
  @sv_name "name"
  @ut_category "category"
  @ut_variable "variable"
  @ut_timing "timing"
  @ut_label "label"

  def tracker_version, do: @tracker_version

  # POST Requests
  def post_protocol_vendor, do: @post_protocol_vendor
  def post_protocol_version, do: @post_protocol_version
  def post_content_type, do: @post_content_type
  def post_wrapper_bytes, do: @post_wrapper_bytes
  def post_stm_bytes, do: @post_stm_bytes

  # GET Requests
  def get_protocol_path, do: @get_protocol_path

  # Schema Versions
  def schema_payload_data, do: @schema_payload_data
  def schema_contexts, do: @schema_contexts

  def schema_unstruct_event, do: @schema_unstruct_event

  def schema_screen_view, do: @schema_screen_view
  def schema_user_timings, do: @schema_user_timings

  # Event Types
  def event_page_view, do: @event_page_view
  def event_structured, do: @event_structured
  def event_unstructured, do: @event_unstructured
  def event_ecomm, do: @event_ecomm
  def event_ecomm_item, do: @event_ecomm_item

  # General
  def schema, do: @schema
  def data, do: @data
  def event, do: @event
  def eid, do: @eid
  def timestamp, do: @timestamp
  def sent_timestamp, do: @sent_timestamp
  def true_timestamp, do: @true_timestamp
  def t_version, do: @t_version
  def app_id, do: @app_id
  def namespace, do: @namespace
  def platform, do: @platform

  def context, do: @context
  def context_encoded, do: @context_encoded
  def unstructured, do: @unstructured
  def unstructured_encoded, do: @unstructured_encoded

  # Subject class
  def uid, do: @uid
  def resolution, do: @resolution
  def viewport, do: @viewport
  def color_depth, do: @color_depth
  def timezone, do: @timezone
  def language, do: @language
  def ip_address, do: @ip_address
  def useragent, do: @useragent
  def domain_uid, do: @domain_uid
  def network_uid, do: @network_uid

  # Page View
  def page_url, do: @page_url
  def page_title, do: @page_title
  def page_refr, do: @page_refr

  # Structured Event
  def se_category, do: @se_category
  def se_action, do: @se_action
  def se_label, do: @se_label
  def se_property, do: @se_property
  def se_value, do: @se_value

  # Ecommerce Transaction
  def tr_id, do: @tr_id
  def tr_total, do: @tr_total
  def tr_affiliation, do: @tr_affiliation
  def tr_tax, do: @tr_tax
  def tr_shipping, do: @tr_shipping
  def tr_city, do: @tr_city
  def tr_state, do: @tr_state
  def tr_country, do: @tr_country
  def tr_currency, do: @tr_currency

  # Transaction Item
  def ti_item_id, do: @ti_item_id
  def ti_item_sku, do: @ti_item_sku
  def ti_item_name, do: @ti_item_name
  def ti_item_category, do: @ti_item_category
  def ti_item_price, do: @ti_item_price
  def ti_item_quantity, do: @ti_item_quantity
  def ti_item_currency, do: @ti_item_currency

  # Screen View
  def sv_id, do: @sv_id
  def sv_name, do: @sv_name

  # User Timing
  def ut_category, do: @ut_category
  def ut_variable, do: @ut_variable
  def ut_timing, do: @ut_timing
  def ut_label, do: @ut_label
end
