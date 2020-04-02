class Todo < ApplicationRecord
  belongs_to :user

  def self.reset_unfinished
    Todo.find_each do
        |todo|
        if todo[:state] == "En proceso"
            todo.update(
                {
                    state: "Nueva"
                }
            )
        end
    end
  end
end
