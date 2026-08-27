const API_URL = import.meta.env.VITE_API_URL || 'http://100.59.91.35/api';

async function handleResponse(res) {
  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    throw new Error(data.message || 'Something went wrong');
  }
  return res.json();
}

export const fetchTodos = () => fetch(`${API_URL}/todos`).then(handleResponse);

export const addTodo = (text) =>
  fetch(`${API_URL}/todos`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ text }),
  }).then(handleResponse);

export const updateTodo = (id, updates) =>
  fetch(`${API_URL}/todos/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(updates),
  }).then(handleResponse);

export const deleteTodo = (id) =>
  fetch(`${API_URL}/todos/${id}`, {
    method: 'DELETE',
  }).then(handleResponse);
