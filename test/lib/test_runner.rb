class TestRunner < Sowing::TestBase
  sub_test_case '#create' do
    test 'insert users from csv' do
      runner = Sowing::Runner.new(data_directory: 'test/fixtures/csv')

      runner.create(User)

      assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
      assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }
    end
  end

  sub_test_case '#create_or_do_nothing' do
    test 'insert users form csv' do
      runner = Sowing::Runner.new(data_directory: 'test/fixtures/csv')

      runner.create_or_do_nothing(User, :first_name)

      assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
      assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }

      runner.create_or_do_nothing(User, :first_name)

      assert { User.where(first_name: 'Carlotta').count == 1 }

      user = User.find_by(first_name: 'Carlotta')
      assert { user.created_at == user.updated_at }
    end
  end
end
