class Strategies::TestActiveRecordYaml < Sowing::TestBase
  setup do
    @runner = Sowing::Runner.new(data_directory: 'test/fixtures/yaml')
  end

  test 'insert users from yaml' do
    @runner.create(User)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }
  end

  test 'insert users or do nothing form yaml' do
    @runner.create_or_skip(User, :first_name)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }

    @runner.create_or_skip(User, :first_name)

    assert { User.where(first_name: 'Carlotta').count == 1 }

    user = User.find_by(first_name: 'Carlotta')
    assert { user.created_at == user.updated_at }
  end

  test 'insert or update users form yaml' do
    @runner.create_or_update(User, :first_name)

    assert { match_array?(User.pluck(:first_name), %w(Carlotta 中平)) }
    assert { match_array?(User.pluck(:last_name), %w(Wilkinson 薫)) }

    @runner.create_or_update(User, :first_name, filename: 'update_users.yml')

    assert { User.where(first_name: 'Carlotta').count == 1 }

    user = User.find_by(first_name: 'Carlotta')
    assert { user.created_at != user.updated_at }
    assert { user.last_name == 'Waelchi' }
  end

  sub_test_case 'relational data' do
    setup do
      @runner.create(User)
    end

    test 'insert' do
      @runner.create(Profile) do
        mapping :user_id do |cel|
          User.find_by(
            first_name: cel['first_name'],
            last_name: cel['last_name']
          ).id
        end
      end

      profile1 = Profile.find_by!(phone: '+1 312-742-2000')
      assert { profile1.address == '2001 N Clark St, Chicago, IL 60614 America' }
      assert { profile1.user.first_name == 'Carlotta' }
      assert { profile1.user.last_name == 'Wilkinson' }

      profile2 = Profile.find_by!(phone: '090-1111-2222')
      assert { profile2.address == '東京都新宿区新宿1-1-1' }
      assert { profile2.user.first_name == '中平' }
      assert { profile2.user.last_name == '薫' }
    end

    test 'insert or do nothing' do
      2.times do
        @runner.create_or_skip(Profile, :phone) do
          mapping :user_id do |cel|
            User.find_by(
              first_name: cel['first_name'],
              last_name: cel['last_name']
            ).id
          end
        end
      end

      assert { Profile.where(phone: '+1 312-742-2000').count == 1 }

      profile = Profile.find_by!(phone: '+1 312-742-2000')
      assert { profile.address == '2001 N Clark St, Chicago, IL 60614 America' }
      assert { profile.user.first_name == 'Carlotta' }
      assert { profile.user.last_name == 'Wilkinson' }
      assert { profile.created_at == profile.updated_at }
    end

    test 'insert or update' do
      @runner.create_or_update(Profile, :phone) do
        mapping :user_id do |cel|
          User.find_by(
            first_name: cel['first_name'],
            last_name: cel['last_name']
          ).id
        end
      end

      profile = Profile.find_by!(phone: '+1 312-742-2000')
      assert { profile.address == '2001 N Clark St, Chicago, IL 60614 America' }
      assert { profile.user.first_name == 'Carlotta' }
      assert { profile.user.last_name == 'Wilkinson' }

      @runner.create_or_update(Profile, :phone, filename: 'update_profiles.yml') do
        mapping :user_id do |cel|
          User.find_by(
            first_name: cel['first_name'],
            last_name: cel['last_name']
          ).id
        end
      end

      assert { Profile.where(phone: '+1 312-742-2000').count == 1 }

      profile.reload
      assert { profile.address == '4548 Sweetwater Rd, Bonita, CA 91902 America' }
      assert { profile.user.first_name == 'Carlotta' }
      assert { profile.user.last_name == 'Wilkinson' }
    end
  end
end
