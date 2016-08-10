class SampleTest < TestBase
  test 'hoge' do
    p User.create(first_name: 'kazuki', last_name: 'baba')
    # assert true
  end
end
