class TestRunner < Sowing::TestBase
  sub_test_case '#create' do
    test 'insert users from csv' do
      runner = Sowing::Runner.new(data_directory: 'test/fixtures/csv')

      runner.create(User)

      assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
      assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }
    end
  end
end
