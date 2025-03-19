[33mcommit 52cb2ee809fe60323a2a48bcbed52fd0de6f4d98[m
Author: VitsVi <jigulsky.vitalik@yandex.ru>
Date:   Wed Mar 19 16:53:33 2025 +0300

    test

[1mdiff --git a/colledge_db.py b/colledge_db.py[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/venv/Lib/site-packages/_distutils_hack/__init__.py b/venv/Lib/site-packages/_distutils_hack/__init__.py[m
[1mnew file mode 100644[m
[1mindex 0000000..f987a53[m
[1m--- /dev/null[m
[1m+++ b/venv/Lib/site-packages/_distutils_hack/__init__.py[m
[36m@@ -0,0 +1,222 @@[m
[32m+[m[32m# don't import any costly modules[m
[32m+[m[32mimport sys[m
[32m+[m[32mimport os[m
[32m+[m
[32m+[m
[32m+[m[32mis_pypy = '__pypy__' in sys.builtin_module_names[m
[32m+[m
[32m+[m
[32m+[m[32mdef warn_distutils_present():[m
[32m+[m[32m    if 'distutils' not in sys.modules:[m
[32m+[m[32m        return[m
[32m+[m[32m    if is_pypy and sys.version_info < (3, 7):[m
[32m+[m[32m        # PyPy for 3.6 unconditionally imports distutils, so bypass the warning[m
[32m+[m[32m        # https://foss.heptapod.net/pypy/pypy/-/blob/be829135bc0d758997b3566062999ee8b23872b4/lib-python/3/site.py#L250[m
[32m+[m[32m        return[m
[32m+[m[32m    import warnings[m
[32m+[m
[32m+[m[32m    warnings.warn([m
[32m+[m[32m        "Distutils was imported before Setuptools, but importing Setuptools "[m
[32m+[m[32m        "also replaces the `distutils` module in `sys.modules`. This may lead "[m
[32m+[m[32m        "to undesirable behaviors or errors. To avoid these issues, avoid "[m
[32m+[m[32m        "using distutils directly, ensure that setuptools is installed in the "[m
[32m+[m[32m        "traditional way (e.g. not an editable install), and/or make sure "[m
[32m+[m[32m        "that setuptools is always imported before distutils."[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32mdef clear_distutils():[m
[32m+[m[32m    if 'distutils' not in sys.modules:[m
[32m+[m[32m        return[m
[32m+[m[32m    import warnings[m
[32m+[m
[32m+[m[32m    warnings.warn("Setuptools is replacing distutils.")[m
[32m+[m[32m    mods = [[m
[32m+[m[32m        name[m
[32m+[m[32m        for name in sys.modules[m
[32m+[m[32m        if name == "distutils" or name.startswith("distutils.")[m
[32m+[m[32m    ][m
[32m+[m[32m    for name in mods:[m
[32m+[m[32m        del sys.modules[name][m
[32m+[m
[32m+[m
[32m+[m[32mdef enabled():[m
[32m+[m[32m    """[m
[32m+[m[32m    Allow selection of distutils by environment variable.[m
[32m+[m[32m    """[m
[32m+[m[32m    which = os.environ.get('SETUPTOOLS_USE_DISTUTILS', 'local')[m
[32m+[m[32m    return which == 'local'[m
[32m+[m
[32m+[m
[32m+[m[32mdef ensure_local_distutils():[m
[32m+[m[32m    import importlib[m
[32m+[m
[32m+[m[32m    clear_distutils()[m
[32m+[m
[32m+[m[32m    # With the DistutilsMetaFinder in place,[m
[32m+[m[32m    # perform an import to cause distutils to be[m
[32m+[m[32m    # loaded from setuptools._distutils. Ref #2906.[m
[32m+[m[32m    with shim():[m
[32m+[m[32m        importlib.import_module('distutils')[m
[32m+[m
[32m+[m[32m    # check that submodules load as expected[m
[32m+[m[32m    core = importlib.import_module('distutils.core')[m
[32m+[m[32m    assert '_distutils' in core.__file__, core.__file__[m
[32m+[m[32m    assert 'setuptools._distutils.log' not in sys.modules[m
[32m+[m
[32m+[m
[32m+[m[32mdef do_override():[m
[32m+[m[32m    """[m
[32m+[m[32m    Ensure that the local copy of distutils is preferred over stdlib.[m
[32m+[m
[32m+[m[32m    See https://github.com/pypa/setuptools/issues/417#issuecomment-392298401[m
[32m+[m[32m    for more motivation.[m
[32m+[m[32m    """[m
[32m+[m[32m    if enabled():[m
[32m+[m[32m        warn_distutils_present()[m
[32m+[m[32m        ensure_local_distutils()[m
[32m+[m
[32m+[m
[32m+[m[32mclass _TrivialRe:[m
[32m+[m[32m    def __init__(self, *patterns):[m
[32m+[m[32m        self._patterns = patterns[m
[32m+[m
[32m+[m[32m    def match(self, string):[m
[32m+[m[32m        return all(pat in string for pat in self._patterns)[m
[32m+[m
[32m+[m
[32m+[m[32mclass DistutilsMetaFinder:[m
[32m+[m[32m    def find_spec(self, fullname, path, target=None):[m
[32m+[m[32m        # optimization: only consider top level modules and those[m
[32m+[m[32m        # found in the CPython test suite.[m
[32m+[m[32m        if path is not None and not fullname.startswith('test.'):[m
[32m+[m[32m            return[m
[32m+[m
[32m+[m[32m        method_name = 'spec_for_{fullname}'.format(**locals())[m
[32m+[m[32m        method = getattr(self, method_name, lambda: None)[m
[32m+[m[32m        return method()[m
[32m+[m
[32m+[m[32m    def spec_for_distutils(self):[m
[32m+[m[32m        if self.is_cpython():[m
[32m+[m[32m            return[m
[32m+[m
[32m+[m[32m        import importlib[m
[32m+[m[32m        import importlib.abc[m
[32m+[m[32m        import importlib.util[m
[32m+[m
[32m+[m[32m        try:[m
[32m+[m[32m            mod = importlib.import_module('setuptools._distutils')[m
[32m+[m[32m        except Exception:[m
[32m+[m[32m            # There are a couple of cases where setuptools._distutils[m
[32m+[m[32m            # may not be present:[m
[32m+[m[32m            # - An older Setuptools without a local distutils is[m
[32m+[m[32m            #   taking precedence. Ref #2957.[m
[32m+[m[32m            # - Path manipulation during sitecustomize removes[m
[32m+[m[32m            #   setuptools from the path but only after the hook[m
[32m+[m[32m            #   has been loaded. Ref #2980.[m
[32m+[m[32m            # In either case, fall back to stdlib behavior.[m
[32m+[m[32m            return[m
[32m+[m
[32m+[m[32m        class DistutilsLoader(importlib.abc.Loader):[m
[32m+[m[32m            def create_module(self, spec):[m
[32m+[m[32m                mod.__name__ = 'distutils'[m
[32m+[m[32m                return mod[m
[32m+[m
[32m+[m[32m            def exec_module(self, module):[m
[32m+[m[32m                pass[m
[32m+[m
[32m+[m[32m        return importlib.util.spec_from_loader([m
[32m+[m[32m            'distutils', DistutilsLoader(), origin=mod.__file__[m
[32m+[m[32m        )[m
[32m+[m
[32m+[m[32m    @staticmethod[m
[32m+[m[32m    def is_cpython():[m
[32m+[m[32m        """[m
[32m+[m[32m        Suppress supplying distutils for CPython (build and tests).[m
[32m+[m[32m        Ref #2965 and #3007.[m
[32m+[m[32m        """[m
[32m+[m[32m        return os.path.isfile('pybuilddir.txt')[m
[32m+[m
[32m+[m[32m    def spec_for_pip(self):[m
[32m+[m[32m        """[m
[32m+[m[32m        Ensure stdlib distutils when running under pip.[m
[32m+[m[32m        See pypa/pip#8761 for rationale.[m
[32m+[m[32m        """[m
[32m+[m[32m        if self.pip_imported_during_build():[m
[32m+[m[32m            return[m
[32m+[m[32m        clear_distutils()[m
[32m+[m[32m        self.spec_for_distutils = lambda: None[m
[32m+[m
[32m+[m[32m    @classmethod[m
[32m+[m[32m    def pip_imported_during_build(cls):[m
[32m+[m[32m        """[m
[32m+[m[32m        Detect if pip is being imported in a build script. Ref #2355.[m
[32m+[m[32m        """[m
[32m+[m[32m        import traceback[m
[32m+[m
[32m+[m[32m        return any([m
[32m+[m[32m            cls.frame_file_is_setup(frame) for frame, line in traceback.walk_stack(None)[m
[32m+[m[32m        )[m
[32m+[m
[32m+[m[32m    @staticmethod[m
[32m+[m[32m    def frame_file_is_setup(frame):[m
[32m+[m[32m        """[m
[32m+[m[32m        Return True if the indicated frame suggests a setup.py file.[m
[32m+[m[32m        """[m
[32m+[m[32m        # some frames may not have __file__ (#2940)[m
[32m+[m[32m        return frame.f_globals.get('__file__', '').endswith('setup.py')[m
[32m+[m
[32m+[m[32m    def spec_for_sensitive_tests(self):[m
[32m+[m[32m        """[m
[32m+[m[32m        Ensure stdlib distutils when running select tests under CPython.[m
[32m+[m
[32m+[m[32m        python/cpython#91169[m
[32m+[m[32m        """[m
[32m+[m[32m        clear_distutils()[m
[32m+[m[32m        self.spec_for_distutils = lambda: None[m
[32m+[m
[32m+[m[32m    sensitive_tests = ([m
[32m+[m[32m        [[m
[32m+[m[32m            'test.test_distutils',[m
[32m+[m[32m            'test.test_peg_generator',[m
[32m+[m[32m            'test.test_importlib',[m
[32m+[m[32m        ][m
[32m+[m[32m        if sys.version_info < (3, 10)[m
[32m+[m[32m        else [[m
[32m+[m[32m            'test.test_distutils',[m
[32m+[m[32m        ][m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32mfor name in DistutilsMetaFinder.sensitive_tests:[m
[32m+[m[32m    setattr([m
[32m+[m[32m        DistutilsMetaFinder,[m
[32m+[m[32m        f'spec_for_{name}',[m
[32m+[m[32m        DistutilsMetaFinder.spec_for_sensitive_tests,[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32mDISTUTILS_FINDER = DistutilsMetaFinder()[m
[32m+[m
[32m+[m
[32m+[m[32mdef add_shim():[m
[32m+[m[32m    DISTUTILS_FINDER in sys.meta_path or insert_shim()[m
[32m+[m
[32m+[m
[32m+[m[32mclass shim:[m
[32m+[m[32m    def __enter__(self):[m
[32m+[m[32m        insert_shim()[m
[32m+[m
[32m+[m[32m    def __exit__(self, exc, value, tb):[m
[32m+[m[32m        remove_shim()[m
[32m+[m
[32m+[m
[32m+[m[32mdef insert_shim():[m
[32m+[m[32m    sys.meta_path.insert(0, DISTUTILS_FINDER)[m
[32m+[m
[32m+[m
[32m+[m[32mdef remove_shim():[m
[32m+[m[32m    try:[m
[32m+[m[32m        sys.meta_path.remove(DISTUTILS_FINDER)[m
[32m+[m[32m    except ValueError:[m
[32m+[m[32m        pass[m
[1mdiff --git a/venv/Lib/site-packages/_distutils_hack/__pycache__/__init__.cpython-311.pyc b/venv/Lib/site-packages/_distutils_hack/__pycache__/__init__.cpython-311.pyc[m
[1mnew file mode 100644[m
[1mindex 0000000..babb3c9[m
Binary files /dev/null and b/venv/Lib/site-packages/_distutils_hack/__pycache__/__init__.cpython-311.pyc differ
[1mdiff --git a/venv/Lib/site-packages/_distutils_hack/__pycache__/override.cpython-311.pyc b/venv/Lib/site-packages/_distutils_hack/__pycache__/override.cpython-311.pyc[m
[1mnew file mode 100644[m
[1mindex 0000000..14763f2[m
Binary files /dev/null and b/venv/Lib/site-packages/_distutils_hack/__pycache__/override.cpython-311.pyc differ
[1mdiff --git a/venv/Lib/site-packages/_distutils_hack/override.py b/venv/Lib/site-packages/_distutils_hack/override.py[m
[1mnew file mode 100644[m
[1mindex 0000000..2cc433a[m
[1m--- /dev/null[m
[1m+++ b/venv/Lib/site-packages/_distutils_hack/override.py[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m__import__('_distutils_hack').do_override()[m
[1mdiff --git a/venv/Lib/site-packages/distutils-precedence.pth b/venv/Lib/site-packages/distutils-precedence.pth[m
[1mnew file mode 100644[m
[1mindex 0000000..7f009fe[m
[1m--- /dev/null[m
[1m+++ b/venv/Lib/site-packages/distutils-precedence.pth[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32mimport os; var = 'SETUPTOOLS_USE_DISTUTILS'; enabled = os.environ.get(var, 'local') == 'local'; enabled and __import__('_distutils_hack').add_shim();[m[41m [m
[1mdiff --git a/venv/Lib/site-packages/pip-24.0.dist-info/AUTHORS.txt b/venv/Lib/site-packages/pip-24.0.dist-info/AUTHORS.txt[m
[1mnew file mode 100644[m
[1mindex 0000000..0e63548[m
[1m--- /dev/null[m
[1m+++ b/venv/Lib/site-packages/pip-24.0.dist-info/AUTHORS.txt[m
[36m@@ -0,0 +1,760 @@[m
[32m+[m[32m@Switch01[m
[32m+[m[32mA_Rog[m
[32m+[m[32mAakanksha Agrawal[m
[32m+[m[32mAbhinav Sagar[m
[32m+[m[32mABHYUDAY PRATAP SINGH[m
[32m+[m[32mabs51295[m
[32m+[m[32mAceGentile[m
[32m+[m[32mAdam Chainz[m
[32m+[m[32mAdam Tse[m
[32m+[m[32mAdam Wentz[m
[32m+[m[32madmin[m
[32m+[m[32mAdrien Morison[m
[32m+[m[32mahayrapetyan[m
[32m+[m[32mAhilya[m
[32m+[m[32mAinsworthK[m
[32m+[m[32mAkash Srivastava[m
[32m+[m[32mAlan Yee[m
[32m+[m[32mAlbert Tugushev[m
[32m+[m[32mAlbert-Guan[m
[32m+[m[32malbertg[m
[32m+[m[32mAlberto Sottile[m
[32m+[m[32mAleks Bunin[m
[32m+[m[32mAles Erjavec[m
[32m+[m[32mAlethea Flowers[m
[32m+[m[32mAlex Gaynor[m
[32m+[m[32mAlex Grönholm[m
[32m+[m[32mAlex Hedges[m
[32m+[m[32mAlex Loosley[m
[32m+[m[32mAlex Morega[m
[32m+[m[32mAlex Stachowiak[m
[32m+[m[32mAlexander Shtyrov[m
[32m+[m[32mAlexandre Conrad[m
[32m+[m[32mAlexey Popravka[m
[32m+[m[32mAleš Erjavec[m
[32m+[m[32mAlli[m
[32m+[m[32mAmi Fischman[m
[32m+[m[32mAnanya Maiti[m
[32m+[m[32mAnatoly Techtonik[m
[32m+[m[32mAnders Kaseorg[m
[32m+[m[32mAndre Aguiar[m
[32m+[m[32mAndreas Lutro[m
[32m+[m[32mAndrei Geacar[m
[32m+[m[32mAndrew Gaul[m
[32m+[m[32mAndrew Shymanel[m
[32m+[m[32mAndrey Bienkowski[m
[32m+[m[32mAndrey Bulgakov[m
[32m+[m[32mAndrés Delfino[m
[32m+[m[32mAndy Freeland[m
[32m+[m[32mAndy Kluger[m
[32m+[m[32mAni Hayrapetyan[m
[32m+[m[32mAniruddha Basak[m
[32m+[m[32mAnish Tambe[m
[32m+[m[32mAnrs Hu[m
[32m+[m[32mAnthony Sottile[m
[32m+[m[32mAntoine Musso[m
[32m+[m[32mAnton Ovchinnikov[m
[32m+[m[32mAnton Patrushev[m
[32m+[m[32mAntonio Alvarado Hernandez[m
[32m+[m[32mAntony Lee[m
[32m+[m[32mAntti Kaihola[m
[32m+[m[32mAnubhav Patel[m
[32m+[m[32mAnudit Nagar[m
[32m+[m[32mAnuj Godase[m
[32m+[m[32mAQNOUCH Mohammed[m
[32m+[m[32mAraHaan[m
[32m+[m[32mArindam Choudhury[m
[32m+[m[32mArmin Ronacher[m
[32m+[m[32mArtem[m
[32m+[m[32mArun Babu Neelicattu[m
[32m+[m[32mAshley Manton[m
[32m+[m[32mAshwin Ramaswami[m
[32m+[m[32matse[m
[32m+[m[32mAtsushi Odagiri[m
[32m+[m[32mAvinash Karhana[m
[32m+[m[32mAvner Cohen[m
[32m+[m[32mAwit (Ah-Wit) Ghirmai[m
[32m+[m[32mBaptiste Mispelon[m
[32m+[m[32mBarney Gale[m
[32m+[m[32mbarneygale[m
[32m+[m[32mBartek Ogryczak[m
[32m+[m[32mBastian Venthur[m
[32m+[m[32mBen Bodenmiller[m
[32m+[m[32mBen Darnell[m
[32m+[m[32mBen Hoyt[m
[32m+[m[32mBen Mares[m
[32m+[m[32mBen Rosser[m
[32m+[m[32mBence Nagy[m
[32m+[m[32mBenjamin Peterson[m
[32m+[m[32mBenjamin VanEvery[m
[32m+[m[32mBenoit Pierre[m
[32m+[m[32mBerker Peksag[m
[32m+[m[32mBernard[m
[32m+[m[32mBernard Tyers[m
[32m+[m[32mBernardo B. Marques[m
[32m+[m[32mBernhard M. Wiedemann[m
[32m+[m[32mBertil Hatt[m
[32m+[m[32mBhavam Vidyarthi[m
[32m+[m[32mBlazej Michalik[m
[32m+[m[32mBogdan Opanchuk[m
[32m+[m[32mBorisZZZ[m
[32m+[m[32mBrad Erickson[m
[32m+[m[32mBradley Ayers[m
[32m+[m[32mBrandon L. Reiss[m
[32m+[m[32mBrandt Bucher[m
[32m+[m[32mBrett Randall[m
[32m+[m[32mBrett Rosen[m
[32m+[m[32mBrian Cristante[m
[32m+[m[32mBrian Rosner[m
[32m+[m[32mbriantracy[m
[32m+[m[32mBrownTruck[m
[32m+[m[32mBruno Oliveira[m
[32m+[m[32mBruno Renié[m
[32m+[m[32mBruno S[m
[32m+[m[32mBstrdsmkr[m
[32m+[m[32mBuck Golemon[m
[32m+[m[32mburrows[m
[32m+[m[32mBussonnier Matthias[m
[32m+[m[32mbwoodsend[m
[32m+[m[32mc22[m
[32m+[m[32mCaleb Martinez[m
[32m+[m[32mCalvin Smith[m
[32m+[m[32mCarl Meyer[m
[32m+[m[32mCarlos Liam[m
[32m+[m[32mCarol Willing[m
[32m+[m[32mCarter Thayer[m
[32m+[m[32mCass[m
[32m+[m[32mChandrasekhar Atina[m
[32m+[m[32mChih-Hsuan Yen[m
[32m+[m[32mChris Brinker[m
[32m+[m[32mChris Hunt[m
[32m+[m[32mChris Jerdonek[m
[32m+[m[32mChris Kuehl[m
[32m+[m[32mChris McDonough[m
[32m+[m[32mChris Pawley[m
[32m+[m[32mChris Pryer[m
[32m+[m[32mChris Wolfe[m
[32m+[m[32mChristian Clauss[m
[32m+[m[32mChristian Heimes[m
[32m+[m[32mChristian Oudard[m
[32m+[m[32mChristoph Reiter[m
[32m+[m[32mChristopher Hunt[m
[32m+[m[32mChristopher Snyder[m
[32m+[m[32mcjc7373[m
[32m+[m[32mClark Boylan[m
[32m+[m[32mClaudio Jolowicz[m
[32m+[m[32mClay McClure[m
[32m+[m[32mCody[m
[32m+[m[32mCody Soyland[m
[32m+[m[32mColin Watson[m
[32m+[m[32mCollin Anderson[m
[32m+[m[32mConnor Osborn[m
[32m+[m[32mCooper Lees[m
[32m+[m[32mCooper Ry Lees[m
[32m+[m[32mCory Benfield[m
[32m+[m[32mCory Wright[m
[32m+[m[32mCraig Kerstiens[m
[32m+[m[32mCristian Sorinel[m
[32m+[m[32mCristina[m
[32m+[m[32mCristina Muñoz[m
[32m+[m[32mCurtis Doty[m
[32m+[m[32mcytolentino[m
[32m+[m[32mDaan De Meyer[m
[32m+[m[32mDale[m
[32m+[m[32mDamian[m
[32m+[m[32mDamian Quiroga[m
[32m+[m[32mDamian Shaw[m
[32m+[m[32mDan Black[m
[32m+[m[32mDan Savilonis[m
[32m+[m[32mDan Sully[m
[32m+[m[32mDane Hillard[m
[32m+[m[32mdaniel[m
[32m+[m[32mDaniel Collins[m
[32m+[m[32mDaniel Hahler[m
[32m+[m[32mDaniel Holth[m
[32m+[m[32mDaniel Jost[m
[32m+[m[32mDaniel Katz[m
[32m+[m[32mDaniel Shaulov[m
[32m+[m[32mDaniele Esposti[m
[32m+[m[32mDaniele Nicolodi[m
[32m+[m[32mDaniele Procida[m
[32m+[m[32mDaniil Konovalenko[m
[32m+[m[32mDanny Hermes[m
[32m+[m[32mDanny McClanahan[m
[32m+[m[32mDarren Kavanagh[m
[32m+[m[32mDav Clark[m
[32m+[m[32mDave Abrahams[m
[32m+[m[32mDave Jones[m
[32m+[m[32mDavid Aguilar[m
[32m+[m[32mDavid Black[m
[32m+[m[32mDavid Bordeynik[m
[32m+[m[32mDavid Caro[m
[32m+[m[32mDavid D Lowe[m
[32m+[m[32mDavid Evans[m
[32m+[m[32mDavid Hewitt[m
[32m+[m[32mDavid Linke[m
[32m+[m[32mDavid Poggi[m
[32m+[m[32mDavid Pursehouse[m
[32m+[m[32mDavid Runge[m
[32m+[m[32mDavid Tucker[m
[32m+[m[32mDavid Wales[m
[32m+[m[32mDavidovich[m
[32m+[m[32mddelange[m
[32m+[m[32mDeepak Sharma[m
[32m+[m[32mDeepyaman Datta[m
[32m+[m[32mDenise Yu[m
[32m+[m[32mdependabot[bot][m
[32m+[m[32mderwolfe[m
[32m+[m[32mDesetude[m
[32m+[m[32mDevesh Kumar Singh[m
[32m+[m[32mDiego Caraballo[m
[32m+[m[32mDiego Ramirez[m
[32m+[m[32mDiegoCaraballo[m
[32m+[m[32mDimitri Merejkowsky[m
[32m+[m[32mDimitri Papadopoulos[m
[32m+[m[32mDirk Stolle[m
[32m+[m[32mDmitry Gladkov[m
[32m+[m[32mDmitry Volodin[m
[32m+[m[32mDomen Kožar[m
[32m+[m[32mDominic Davis-Foster[m
[32m+[m[32mDonald Stufft[m
[32m+[m[32mDongweiming[m
[32m+[m[32mdoron zarhi[m
[32m+[m[32mDos Moonen[m
[32m+[m[32mDouglas Thor[m
[32m+[m[32mDrFeathers[m
[32m+[m[32mDustin Ingram[m
[32m+[m[32mDwayne Bailey[m
[32m+[m[32mEd Morley[m
[32m+[m[32mEdgar Ramírez[m
[32m+[m[32mEdgar Ramírez Mondragón[m
[32m+[m[32mEe Durbin[m
[32m+[m[32mEfflam Lemaillet[m
[32m+[m[32mefflamlemaillet[m
[32m+[m[32mEitan Adler[m
[32m+[m[32mekristina[m
[32m+[m[32melainechan[m
[32m+[m[32mEli Schwartz[m
[32m+[m[32mElisha Hollander[m
[32m+[m[32mEllen Marie Dash[m
[32m+[m[32mEmil Burzo[m
[32m+[m[32mEmil Styrke[m
[32m+[m[32mEmmanuel Arias[m
[32m+[m[32mEndoh Takanao[m
[32m+[m[32menoch[m
[32m+[m[32mErdinc Mutlu[m
[32m+[m[32mEric Cousineau[m
[32m+[m[32mEric Gillingham[m
[32m+[m[32mEric Hanchrow[m
[32m+[m[32mEric Hopper[m
[32m+[m[32mErik M. Bray[m
[32m+[m[32mErik Rose[m
[32m+[m[32mErwin Janssen[m
[32m+[m[32mEugene Vereshchagin[m
[32m+[m[32meverdimension[m
[32m+[m[32mFederico[m
[32m+[m[32mFelipe Peter[m
[32m+[m[32mFelix Yan[m
[32m+[m[32mfiber-space[m
[32m+[m[32mFilip Kokosiński[m
[32m+[m[32mFilipe Laíns[m
[32m+[m[32mFinn Womack[m
[32m+[m[32mfinnagin[m
[32m+[m[32mFlavio Amurrio[m
[32m+[m[32mFlorian Briand[m
[32m+[m[32mFlorian Rathgeber[m
[32m+[m[32mFrancesco[m
[32m+[m[32mFrancesco Montesano[m
[32m+[m[32mFrost Ming[m
[32m+[m[32mGabriel Curio[m
[32m+[m[32mGabriel de Perthuis[m
[32m+[m[32mGarry Polley[m
[32m+[m[32mgavin[m
[32m+[m[32mgdanielson[m
[32m+[m[32mGeoffrey Sneddon[m
[32m+[m[32mGeorge Song[m
[32m+[m[32mGeorgi Valkov[m
[32m+[m[32mGeorgy Pchelkin[m
[32m+[m[32mghost[m
[32m+[m[32mGiftlin Rajaiah[m
[32m+[m[32mgizmoguy1[m
[32m+[m[32mgkdoc[m
[32m+[m[32mGodefroid Chapelle[m
[32m+[m[32mGopinath M[m
