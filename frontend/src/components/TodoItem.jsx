function TodoItem({ todo, onToggle, onDelete }) {
  return (
    <li className={`todo-item ${todo.completed ? 'completed' : ''}`}>
      <label>
        <input
          type="checkbox"
          checked={todo.completed}
          onChange={() => onToggle(todo)}
        />
        <span>{todo.text}</span>
      </label>
      <button className="delete-btn" onClick={() => onDelete(todo._id)}>
        Delete
      </button>
    </li>
  );
}

export default TodoItem;
