class Todo < ApplicationRecord
  belongs_to :user

  def self.reset_unfinished
    todos = Todo.where(state: "En proceso")
    todos.update_all(state: "Nueva")
  end
end
