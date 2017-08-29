class Strategies::TestActiveRecordCsv < Sowing::TestBase
  setup do
    @runner = Sowing::Runner.new(data_directory: 'test/fixtures/csv')
  end

  test 'insert users from csv' do
    @runner.create(User)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }
  end

  test 'insert users or do nothing form csv' do
    @runner.create_or_skip(User, :first_name)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }

    @runner.create_or_skip(User, :first_name)

    assert { User.where(first_name: 'Carlotta').count == 1 }

    user = User.find_by(first_name: 'Carlotta')
    assert { user.created_at == user.updated_at }
  end

  test 'insert or update users form csv' do
    @runner.create_or_update(User, :first_name)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }

    @runner.create_or_update(User, :first_name, filename: 'update_users.csv')

    assert { User.where(first_name: 'Carlotta').count == 1 }

    user = User.find_by(first_name: 'Carlotta')
    assert { user.created_at != user.updated_at }
    assert { user.last_name == 'Waelchi' }
  end
end
