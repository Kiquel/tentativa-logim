// Supabase Configuration
const supabaseUrl = 'https://YOUR_SUPABASE_URL.supabase.co';
const supabaseKey = 'YOUR_SUPABASE_KEY';
const supabase = supabase.createClient(supabaseUrl, supabaseKey);

let user = null;

document.addEventListener('DOMContentLoaded', () => {
  const loginBtn = document.getElementById('login-btn');
  const loginForm = document.getElementById('login-form');
  const submitLoginBtn = document.getElementById('submit-login');
  const usernameInput = document.getElementById('username');
  const userContainer = document.getElementById('user-container');

  loginBtn.addEventListener('click', () => {
    loginForm.style.display = 'flex';
  });

  submitLoginBtn.addEventListener('click', async () => {
    const username = usernameInput.value.trim();
    if (username) {
      const { data, error } = await supabase
        .from('users')
        .upsert([{ username }], { onConflict: ['username'] });

      if (error) {
        alert('Erro ao cadastrar o usuário!');
      } else {
        user = data[0];
        userContainer.innerHTML = `Bem-vindo, ${user.username}!`;
        loginForm.style.display = 'none';
        loginBtn.style.display = 'none';
      }
    } else {
      alert('Por favor, insira um nome!');
    }
  });
});
