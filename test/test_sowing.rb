class TestSowing < Sowing::TestBase
  sub_test_case 'create' do
    test 'insert users from csv' do
      Sowing.create(User)

      assert { User.pluck(:first_name).sort == %w(Carlotta 中平).sort }
      assert { User.pluck(:last_name).sort == %w(Wilkinson 薫).sort }
    end
  end
end
