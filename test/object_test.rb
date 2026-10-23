require_relative "test_helper"

class ObjectTest < Minitest::Test
  class Sample < Visbook::Object
    attribute :id
    attribute :first_name
    attribute :last_name, key: "surname"
    attribute :nested, type: Visbook::Objects::Currency
    array_attribute :items, type: Visbook::Objects::Currency
  end

  def test_snake_case_attributes_read_camel_case_keys_by_default
    sample = Sample.new("id" => 1, "firstName" => "Jane")

    assert_equal 1, sample.id
    assert_equal "Jane", sample.first_name
  end

  def test_explicit_key_override_is_honored
    assert_equal "Doe", Sample.new("surname" => "Doe").last_name
  end

  def test_typed_attribute_wraps_nested_data
    sample = Sample.new("nested" => {"id" => 5, "name" => "EUR"})

    assert_instance_of Visbook::Objects::Currency, sample.nested
    assert_equal "EUR", sample.nested.name
  end

  def test_array_attribute_wraps_each_element
    sample = Sample.new("items" => [{"id" => 1}, {"id" => 2}])

    assert_equal 2, sample.items.size
    assert(sample.items.all? { |currency| currency.is_a?(Visbook::Objects::Currency) })
  end

  def test_hash_style_access_works
    sample = Sample.new("id" => 1, "firstName" => "Jane")

    assert_equal 1, sample["id"]
    assert_equal "Jane", sample[:firstName]
  end

  def test_keys_and_values_come_from_the_data
    sample = Sample.new("id" => 1, "firstName" => "Jane")

    assert_equal %w[id firstName], sample.keys
    assert_equal [1, "Jane"], sample.values
  end

  def test_to_h_returns_underlying_data
    data = {"id" => 1, "firstName" => "Jane"}

    assert_equal data, Sample.new(data).to_h
  end

  def test_json_serializes_the_underlying_data
    data = {"id" => 1, "firstName" => "Jane"}

    assert_equal data, Sample.new(data).as_json
    assert_equal '{"id":1,"firstName":"Jane"}', Sample.new(data).to_json
  end

  def test_construct_from_nil_returns_nil
    assert_nil Sample.construct_from(nil)
  end

  def test_camelize_converts_snake_case_to_camel_case
    assert_equal "firstName", Visbook::Object.camelize("first_name")
    assert_equal "totalPriceWithVat", Visbook::Object.camelize("total_price_with_vat")
    assert_equal "id", Visbook::Object.camelize("id")
  end

  def test_real_view_model_hydrates_nested_objects
    raw = {
      "id" => "abc",
      "name" => "Hotel Foo",
      "currency" => {"id" => 1, "name" => "NOK"},
      "timeZoneInfo" => {"iana" => "Europe/Oslo", "displayName" => "Oslo"}
    }
    info = Visbook::Objects::CompanyInformation.new(raw)

    assert_equal "abc", info.id
    assert_equal "NOK", info.currency.name
    assert_equal "Europe/Oslo", info.time_zone_info.iana
  end
end
