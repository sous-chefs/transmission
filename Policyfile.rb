# frozen_string_literal: true

name 'transmission'

run_list 'test::default'

named_run_list :default, 'test::default'

cookbook 'transmission', path: '.'
cookbook 'test', path: './test/cookbooks/test'
