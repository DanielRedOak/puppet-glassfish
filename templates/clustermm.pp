<% @instances.each do |instance| -%>
create-local-instance --cluster <% cluster_name %> <% instance %>
<% end -%>
