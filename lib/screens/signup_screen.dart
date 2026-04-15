import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/editorial_input.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/gradient_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _buildModal(context),
          ),
        ),
      ),
    );
  }

  Widget _buildModal(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1C19).withValues(alpha: 0.10),
            blurRadius: 48,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: isWide
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSidePanel(),
                  Expanded(child: _buildForm()),
                ],
              ),
            )
          : _buildForm(),
    );
  }

  Widget _buildSidePanel() {
    return SizedBox(
      width: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B5E20), Color(0xFF0D631B)],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _LeafPatternPainter()),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('DoaUTF', style: AppTextStyles.sideTitle),
                const SizedBox(height: 8),
                Text(
                  'Semeando consciência, colhendo um futuro sustentável para todos.',
                  style: AppTextStyles.sideBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(        
    child: Padding(
      padding: const EdgeInsets.all(36),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crie sua conta', style: AppTextStyles.headline),
            const SizedBox(height: 4),
            Text(
              'Inicie sua jornada no arquivo da sustentabilidade.',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 32),

            const _FieldLabel('NOME COMPLETO'),
            const SizedBox(height: 6),
            const EditorialInput(
              hint: 'Ex: Maria Silva',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),

            const _FieldLabel('DATA DE NASCIMENTO'),
            const SizedBox(height: 6),
            const DatePickerField(),
            const SizedBox(height: 20),

            const _FieldLabel('E-MAIL INSTITUCIONAL'),
            const SizedBox(height: 6),
            const EditorialInput(
              hint: 'usuario@instituicao.edu.br',
              icon: Icons.school_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('SENHA'),
                      const SizedBox(height: 6),
                      EditorialInput(
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('CONFIRMAÇÃO'),
                      const SizedBox(height: 6),
                      EditorialInput(
                        hint: '••••••••',
                        icon: Icons.verified_user_outlined,
                        obscure: _obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            GradientButton(
              label: 'Criar Conta',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // handle submit
                }
              },
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body,
                  text: 'Já possui uma conta? ',
                  children: [
                    TextSpan(text: 'Entrar', style: AppTextStyles.link),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Container(
              height: 1,
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                'Ao se inscrever, você concorda com nossos Termos de Serviço e Relatório de Sustentabilidade.',
                style: AppTextStyles.legal,
                textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.label);
  }
}

class _LeafPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final spine = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..quadraticBezierTo(
        size.width * 0.55, size.height * 0.5,
        size.width * 0.45, size.height * 0.95,
      );
    canvas.drawPath(spine, paint);

    for (var i = 0; i < 8; i++) {
      final t = 0.1 + i * 0.1;
      final sx =
          size.width * 0.5 + (size.width * 0.05 * (i % 2 == 0 ? 1 : -1));
      final sy = size.height * t;
      final ex = i % 2 == 0 ? size.width * 0.9 : size.width * 0.05;
      final ey = sy + size.height * 0.04;
      final path = Path()
        ..moveTo(sx, sy)
        ..quadraticBezierTo(
          (sx + ex) / 2, sy - size.height * 0.01,
          ex, ey,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
