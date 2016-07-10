FactoryGirl.define do
  factory :framework, class: ExtendedArgumentationFramework::Framework do
    skip_create
    initialize_with do
      new("a, b -> c, c-> b, a -> (b -> c)")
    end

    factory :framework_example do
      initialize_with do
        new([
                "b4 -> b3",
                "b3 -> b4",
                "a3 -> a2",
                "a2 -> a1",
                "a1 -> a2",
                "b1 -> b2",
                "b2 -> b1",
                "c1 -> (b2 -> b1)",
                "b3 -> (a3 -> a2)",
                "c2 -> (b3 -> b4)",
                "b1 -> (a1 -> a2)",
                "b2 -> (a2 -> a1)"
            ].join(","))
      end
    end
  end
end
