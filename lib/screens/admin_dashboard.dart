import 'package:flutter/material.dart';
import 'package:doaai/auth/services/token_storage.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  final int totalUsuarios = 1245;
  final int doacoesConcluidas = 890;

  List<Map<String, dynamic>> usuarios = [
    {"nome": "Maria Silva", "email": "maria@email.com", "bloqueado": false},
    {"nome": "João Pedro", "email": "joao.pedro@email.com", "bloqueado": true},
  ];

  List<Map<String, dynamic>> doacoesAtivas = [
    {"item": "Cadeira de Rodas", "doador": "Carlos", "data": "10/10/2023"},
    {"item": "Roupas de Frio", "doador": "Fernanda", "data": "09/10/2023"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _validarAcessoAdmin();
  }

  Future<void> _validarAcessoAdmin() async {
    bool isAdmin = await TokenStorage.instance.getIsAdmin();

    if (!isAdmin) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acesso negado.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _alternarBloqueioUsuario(int index) {
    setState(() {
      usuarios[index]["bloqueado"] = !usuarios[index]["bloqueado"];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          usuarios[index]["bloqueado"]
              ? 'Usuário bloqueado com sucesso.'
              : 'Usuário desbloqueado com sucesso.',
        ),
        backgroundColor: usuarios[index]["bloqueado"]
            ? Colors.red
            : Colors.green,
      ),
    );
  }

  void _fazerLogout() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2D7A1F)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'DoaAi - Backoffice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2D7A1F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: _fazerLogout,
          ),
        ],
      ),
      drawer: _buildMenuLateral(),
      body: Column(
        children: [
          _buildIndicadoresGlobais(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildListaUsuarios(), _buildListaDoacoes()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuLateral() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF2D7A1F)),
            accountName: Text(
              "Administrador Sistema",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text("admin@doaai.com.br"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                color: Color(0xFF2D7A1F),
                size: 40,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Color(0xFF2D7A1F)),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Denúncias de Doações'),
            onTap: () {}, // Futura funcionalidade
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {}, // Futura funcionalidade
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sair do Sistema',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _fazerLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicadoresGlobais() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF2D7A1F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CardIndicador(
              titulo: 'Total de Usuários',
              valor: totalUsuarios.toString(),
              icone: Icons.people_alt_rounded,
              corIcone: Color(0xFF2D7A1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CardIndicador(
              titulo: 'Doações Concluídas',
              valor: doacoesConcluidas.toString(),
              icone: Icons.check_circle_rounded,
              corIcone: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF2D7A1F),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFF2D7A1F),
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.manage_accounts), text: 'Usuários'),
          Tab(icon: Icon(Icons.volunteer_activism), text: 'Doações Ativas'),
        ],
      ),
    );
  }

  Widget _buildListaUsuarios() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = usuarios[index];
        final bool isBloqueado = usuario["bloqueado"];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isBloqueado ? Colors.red[100] : Colors.blue[100],
              child: Icon(
                isBloqueado ? Icons.lock : Icons.person,
                color: isBloqueado ? Colors.red : Colors.blue,
              ),
            ),
            title: Text(
              usuario["nome"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(usuario["email"]),
            trailing: IconButton(
              icon: Icon(
                isBloqueado ? Icons.lock_open : Icons.block,
                color: isBloqueado ? Colors.green : Colors.red,
              ),
              tooltip: isBloqueado ? 'Desbloquear Usuário' : 'Bloquear Usuário',
              onPressed: () => _alternarBloqueioUsuario(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListaDoacoes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: doacoesAtivas.length,
      itemBuilder: (context, index) {
        final doacao = doacoesAtivas[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.orange,
              ),
            ),
            title: Text(
              doacao["item"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Doador: ${doacao["doador"]}\nPostado em: ${doacao["data"]}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
              tooltip: 'Ver detalhes',
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}

class _CardIndicador extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color corIcone;

  const _CardIndicador({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.corIcone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: corIcone, size: 32),
          const SizedBox(height: 12),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
