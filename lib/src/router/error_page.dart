part of 'router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Page'),
        leading: IconButton(
          onPressed: () => context.goNamed(AppRoutes.home.name),
          icon: const Icon(Icons.home),
        ),
      ),
      body: Center(
        child: Text(
          'Page not found',
          style: context.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
