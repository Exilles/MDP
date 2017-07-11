

def error_for_enter_data(id, type, teg, description)
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
    xml << "<data><#{teg}>#{id}</#{teg}></data><errors><error>#{description}</error></errors>"
  xml << "</information>"
end

# def undefined_enter_id(id,type)
#   xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
#     xml << "<data><user_id>#{id}</user_id></data><errors><error>User_id contains invalid characters</error></errors>"
#   xml << "</information>"
# end
#
# def empty_id(type)
#   xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
#     xml << "<data><user_id/></data><errors><error>User_id doesn't enter</error></errors>"
#   xml << "</information>"
# end





