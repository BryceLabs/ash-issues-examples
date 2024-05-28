defmodule AppWeb.SchemaTest do
  use AppWeb.ConnCase

  alias App.Store.Order
  alias App.Store.OrderItem
  alias App.Store.OrderItemModifier

  @order_item_query_without_calcualation_and_aggregate """
    query OrderItem($orderItemId: ID!) {
      orderItem(id: $orderItemId) {
       id
        modifiers {
          id
          total
        }
      }
    }
  """

  @order_item_query_with_calcualation_and_aggregate """
    query OrderItem($orderItemId: ID!) {
      orderItem(id: $orderItemId) {
       id
       subtotal
       modifiersTotal
        modifiers {
          id
          total
        }
      }
    }
  """

  test "query: order_item without calculation and aggregate", %{conn: conn} do
    order = Ash.create!(Order, %{customer_name: "José"})

    order_item =
      Ash.create!(OrderItem, %{
        order_id: order.id,
        product_name: "Cheese",
        quantity: 1,
        price: 10.00
      })

    modifier =
      Ash.create!(OrderItemModifier, %{order_item_id: order_item.id, quantity: 2, price: 2.50})

    conn =
      post(conn, "/gql", %{
        "query" => @order_item_query_without_calcualation_and_aggregate,
        "variables" => %{orderItemId: order_item.id}
      })

    inspect(json_response(conn, 200))

    assert json_response(conn, 200) == %{
             "data" => %{
               "orderItem" => %{
                 "id" => order_item.id,
                 "modifiers" => [
                   %{"id" => modifier.id, "total" => "5.0"}
                 ]
               }
             }
           }
  end

  test "query: order_item with calculation and aggregate", %{conn: conn} do
    order = Ash.create!(Order, %{customer_name: "José"})

    order_item =
      Ash.create!(OrderItem, %{
        order_id: order.id,
        product_name: "Cheese",
        quantity: 1,
        price: 10.00
      })

    modifier =
      Ash.create!(OrderItemModifier, %{order_item_id: order_item.id, quantity: 2, price: 2.50})

    conn =
      post(conn, "/gql", %{
        "query" => @order_item_query_with_calcualation_and_aggregate,
        "variables" => %{orderItemId: order_item.id}
      })

    inspect(json_response(conn, 200))

    assert json_response(conn, 200) == %{
             "data" => %{
               "orderItem" => %{
                 "id" => order_item.id,
                 "subtotal" => "15.0",
                 "modifiersTotal" => "5.0",
                 "modifiers" => [
                   %{"id" => modifier.id, "total" => "5.0"}
                 ]
               }
             }
           }
  end
end
