import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/article.dart';
import '../utils/helper_functions.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> articles = [], filteredArticles = [];
  List<Article> pendingArticles = [];
  bool isLoading = false;
  bool isInitiated = false;
  TextEditingController searchController = TextEditingController();

  Future<void> fetchAndSetArticles() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('articles')
          .doc('data')
          .collection('articles')
          .orderBy('date', descending: true)
          .getSavy()
          .then((event) {
        articles = event.docs
            .map(
                (e) => Article.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        filteredArticles = articles;
        isLoading = false;
        print("articles fetched ${articles.length}");

        notifyListeners();
        // isInitiated = true;
      });
    } catch (error) {
      isLoading = false;
      notifyListeners();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: tr('wrong'),
        desc: error.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> fetchAndSetPendingArticles() async {
    isLoading = true;
    try {
      FirebaseFirestore.instance
          .collection('articles')
          .doc('pending')
          .collection('data')
          .orderBy('date', descending: true)
          .getSavy()
          .then((event) {
        pendingArticles = event.docs
            .map(
                (e) => Article.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        print('pending articles fetched ${pendingArticles.length}');
        isLoading = false;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: Text(tr('wrong')),
                content: Text(error.toString()),
              ));
    }
  }

  List<Article> get getArticles {
    return [...articles];
  }

  sortBy() {
    if (searchController.text.isEmpty) {
      filteredArticles = articles;
      notifyListeners();
      return;
    }
    filteredArticles = articles
        .where(
          (element) => HelperFunctions.matchesSearch(
            searchController.text.toLowerCase().split(" "),
            element.title!,
          ),
        )
        .toList();
    notifyListeners();
  }

  clearSearch() {
    searchController.clear();
    filteredArticles = articles;
  }

  Future<void> addArticle(Article article) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('articles')
          .doc('pending')
          .collection('data')
          .add(article.toJson());

      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('accomplished_successfully'),
        desc: tr('article_added'),
        btnOkOnPress: () {
          fetchAndSetPendingArticles();
          pop();
        },
      ).show();
    } catch (error) {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('wrong'),
        desc: error.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      var assets = articles.firstWhere((element) => element.id == id).image;

      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('articles')
          .doc('data')
          .collection('articles')
          .doc(id)
          .delete();

      await UploadProvider().deleteAllAssets(assets!);

      articles.removeWhere((element) => element.id == id);
      filteredArticles.removeWhere((element) => element.id == id);

      notifyListeners();
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('accomplished_successfully'),
        desc: tr('article_deleted'),
        btnOkOnPress: () {},
      ).show();
    } catch (error) {
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> rejectArticle(String id) async {
    showLoaderDialog(navigationKey.currentContext!);

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc('pending')
          .collection('data')
          .doc(id)
          .delete();

      await UploadProvider().deleteAllAssets(
          pendingArticles.where((element) => id == element.id).first.image!);

      pendingArticles.removeWhere((element) => element.id == id);
      articles.removeWhere((element) => element.id == id);
      filteredArticles.removeWhere((element) => element.id == id);
      pop();
      notifyListeners();
    } catch (error) {
      pop();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> approveArticle(Article article) async {
    showLoaderDialog(navigationKey.currentContext!);
    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc('data')
          .collection('articles')
          .add(article.toJson());

      await FirebaseFirestore.instance
          .collection('articles')
          .doc('pending')
          .collection('data')
          .doc(article.id)
          .delete();

      pendingArticles.removeWhere((element) => element.id == article.id);
      articles.add(article);
      filteredArticles = articles;
      pop();
      notifyListeners();
    } catch (error) {
      pop();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> updateArticle(Article article, String type) async {
    showLoaderDialog(navigationKey.currentContext!);
    try {
      var oldData =
          articles.firstWhere((element) => element.id == article.id).image;
      var newData = article.image;

      switch (type) {
        case 'pending':
          await FirebaseFirestore.instance
              .collection('articles')
              .doc('pending')
              .collection('data')
              .doc(article.id)
              .update(article.toJson());

          articles.removeWhere((element) => element.id == article.id);

          articles.add(article);

          filteredArticles = articles;
          break;

        case 'existing':
          await FirebaseFirestore.instance
              .collection('articles')
              .doc('data')
              .collection('articles')
              .doc(article.id)
              .update(article.toJson());

          pendingArticles.removeWhere((element) => element.id == article.id);
          pendingArticles.add(article);

          break;
      }
      await UploadProvider()
          .deleteOldImages(oldImages: oldData!, newImages: newData!);

      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('accomplished_successfully'),
        desc: tr('article_modified'),
        btnOkOnPress: () {
          pop();
          pop();
        },
      ).show();
      notifyListeners();
    } catch (error) {
      pop();

      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }
}
