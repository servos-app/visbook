require_relative "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @config = Visbook::Configuration.new
  end

  def test_has_default_values
    assert_nil @config.web_entity_id
    assert_equal :production, @config.environment
    assert_equal 30, @config.timeout
    assert_equal 10, @config.open_timeout
    assert_nil @config.logger
    assert_nil @config.default_language
  end

  def test_environment_can_be_set_to_a_valid_value
    @config.environment = :production

    assert_equal :production, @config.environment
  end

  def test_environment_accepts_string_values
    @config.environment = "production"

    assert_equal :production, @config.environment
  end

  def test_environment_raises_for_unknown_values
    assert_raises(ArgumentError) { @config.environment = :staging }
  end

  def test_merge_applies_non_nil_overrides_to_a_copy
    @config.web_entity_id = 1
    @config.timeout = 5

    merged = @config.merge(web_entity_id: 2, timeout: nil, environment: "production")

    assert_equal 2, merged.web_entity_id
    assert_equal 5, merged.timeout
    assert_equal :production, merged.environment
    assert_equal 1, @config.web_entity_id
    assert_raises(ArgumentError) { @config.merge(environment: :staging) }
  end

  def test_base_url_returns_the_host_for_production
    assert_equal "https://ws.visbook.com", @config.base_url
  end
end
