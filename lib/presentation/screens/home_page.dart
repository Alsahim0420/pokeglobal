import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/presentation/providers/example_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;
  String? _exampleResult;
  String? _exampleError;
  bool _loading = false;

  Future<void> _fetchExample() async {
    setState(() {
      _loading = true;
      _exampleResult = null;
      _exampleError = null;
    });
    final useCase = ref.read(getExampleUseCaseProvider);
    final response = await useCase('item-1');
    if (!mounted) return;
    setState(() {
      _loading = false;
      response.when(
        success: (data) {
          _exampleResult = data?.title ?? 'OK';
          _exampleError = null;
        },
        failure: (message, _) {
          _exampleError = message;
          _exampleResult = null;
        },
      );
    });
  }

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            // Ejemplo UseCase + UseCaseResponse
            FilledButton.icon(
              onPressed: _loading ? null : _fetchExample,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_loading ? 'Cargando...' : 'Llamar use case'),
            ),
            if (_exampleResult != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _exampleResult!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (_exampleError != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _exampleError!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
