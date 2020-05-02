require 'key_flatten'

module Twm
  class << self
    #
    # orig: local docs
    # left: generate docs
    # right: local src files
    #
    # condition: merge right into left
    def yaml_merge(left, orig, right)
      flat_orig = KeyFlatten.key_flatten(orig || {}).to_h
      flat_left = KeyFlatten.key_flatten(left || {}).to_h
      flat_right = KeyFlatten.key_flatten(right || {}).to_h

      all_keys = (flat_left.keys + flat_orig.keys + flat_right.keys).uniq

      twm = all_keys.each_with_object({}) do |key, result|
        r = three_equal?(flat_left[key], flat_orig[key], flat_right[key])

        case
        when r[:left_orig] && r[:orig_right] && r[:left_right]
          # no change
          result[key] = flat_orig[key]
        when r[:left_orig] && !r[:orig_right] && !r[:left_right]
          # edited
          result[key] = flat_right[key]
        when !r[:left_orig] && r[:orig_right] && !r[:left_right]
          # generate
          result[key] = flat_left[key]
        when !r[:left_orig] && !r[:orig_right] && r[:left_right]
          # edited
          result[key] = flat_right[key]
        when !r[:left_orig] && !r[:orig_right] && !r[:left_right]
          # conflict => prioritize edited
          result[key] = flat_right[key]
        end
      end

      twm = twm.delete_if{ |k,v| v.nil? }
      KeyFlatten.key_unflatten(twm)
    end

    private

    def three_equal?(left, orig, right)
      case
      when left == orig && orig == right
        {
          left_orig: true,
          orig_right: true,
          left_right: true
        }
      when left == orig && orig != right
        {
          left_orig: true,
          orig_right: false,
          left_right: false
        }
      when left != orig && orig == right
        {
          left_orig: false,
          orig_right: true,
          left_right: false
        }
      when left != orig && orig != right && left == right
        {
          left_orig: false,
          orig_right: false,
          left_right: true
        }
      when left != orig && orig != right && left != right
        {
          left_orig: false,
          orig_right: false,
          left_right: false
        }
      end
    end
  end
end


