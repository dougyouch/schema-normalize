# schema-normalize

Basic concept is to apply filtering/normalization methods to attributes.  Primary interface is to call normalize on the model.  This way you can control when the methods are applied.

```
class Person < ActiveRecord::Base
  include Schema::Normalize

  normalize :name, :strip, if: :name_changed?
  normalize :value, :round, args: [2], if: :value_changed?

  before_validation :normalize
end
```
