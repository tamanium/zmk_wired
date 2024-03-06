@echo off
rem UTF-8
chcp 65001 >NUL
rem Shift-JIS
rem chcp 932 >NUL
rem 遅延変数の設定
setlocal enabledelayedexpansion
set title=git操作
set Yes=6
set No=7
set Cancel=2

for /f %%i in ('cmd /k prompt $e^<nul') do set ESC=%%i

set WHITE=%ESC%[0m
set GREY=%ESC%[90m
set RED=%ESC%[91m
set GREEN=%ESC%[92m
set YELLOW=%ESC%[93m
set BLUE=%ESC%[94m
set CYAN=%ESC%[96m


rem ----------メインメソッド開始----------


rem リポジトリフォルダ新規作成
if not exist .git (
	call:MsgBox リポジトリがありません`n新規作成しますか? YesNo
	if !errorlevel!==%No% ( exit )
	git init > nul
	git add . > nul
	call:InputComment comment
	if !comment!==none (
		rmdir .git /s /q
		goto END
	)
	call:git_commit !comment!
	for /f "usebackq tokens=2" %%a in (`git branch --contains`) do set branch=%%a
	call:MsgBox ・現在のブランチ:!branch!`n・コメント:!comment!`n`n終了します OK コミット成功
	exit
)

for /f "usebackq tokens=1,2" %%a in (`git branch`) do (
	if %%a==* (
		echo ブランチ...◎%YELLOW%%%b%WHITE%
	) else (
		set _msg=  %%a
		echo %GREY%　　　　    %%a%WHITE%
	)
)
echo.

git add .

rem 編集されたファイル名を表示
echo 編集されたファイル
set IsFiles=false
for /f "usebackq tokens=*" %%a in (`git diff --cached --name-only`) do (
	set IsFiles=true
)
rem 編集無き場合はその旨表示して終了
if %IsFiles%==false (
	git reset HEAD >nul
	call:MsgBox 編集されたファイルはありません`n終了します OK
	exit
)


call:git_diff A 追加 %GREEN%
call:git_diff C 複製 %BLUE%
call:git_diff M 更新 %YELLOW%
call:git_diff R 改名 %CYAN% 
call:git_diff D 削除 %RED%
echo %ESC%[0m

echo.

call:InputComment comment
if %commnet%==none (
	git reset HEAD >nul
) else (
	call:git_commit comment
)

pause
exit

echo.

:WHILE
	call:InputComment comment
	if %comment%==none (
		call:MsgBox コミットをキャンセルしますか? YesNo
		if !errorlevel!==%No% (goto WHILE)
		goto END
	)

git add -u

:END
pause
exit



rem --------------------------------
rem ----------ファイル確認----------
rem --------------------------------
:git_diff
	set init=true
	for /f "usebackq tokens=2 delims=	" %%a in (`git diff --cached --name-status --diff-filter=%1`) do (
		if !init!==true (
			set init==false
			echo %3%2...%%a
		) else (
			echo 　　   %%a
		) 
	)
exit /b


rem --------------------------------
rem ----------コミット処理----------
rem --------------------------------
:git_commits
	set msg1==%1
	rem set msg2==%2
	rem set msg3==%3
	if  "%msg1%"=="" (
		git commit -m no_comment > nul
	) else (
		git commit -m %1 > nul
	)
exit /b

rem --------------------------------
rem ----------コミット処理----------
rem --------------------------------
:git_commit 
	rem ----複数行対応----
	rem ----スペース対応----
	git commit -m %1 > nul
exit /b

rem --------------------------------------------
rem ----------メッセージボックスの表示----------
rem --------------------------------------------
:MsgBox
	set _btn=%2
	if "%_btn%" == "" ( set _btn=YesNo )
	set _title=%3
	if "%_title%" == "" ( set _title=%title% )
	powershell -Command^
	"Add-Type -AssemblyName System.Windows.Forms;$result = [System.Windows.Forms.MessageBox]::Show(\"%1\", '%_title%', '%_btn%', 'Asteris');exit $result;"
exit /b

rem ----------------------------------
rem ----------コメントの入力----------
rem ----------------------------------
:InputComment
	:WHILE1
		echo Input your comment
		echo [cancel...only Enter]
		echo.
		set _comment=
		set /p _comment="->"

		rem コメント無き場合は終了
		if "!_comment!"=="" (
			set _comment=none
		) else (
			call:MsgBox Commit with this comment?`n`n「!_comment!」 YesNo
			if !errorlevel!==%No% ( goto WHILE1 )
		)
	endlocal && set %1=%_comment%
exit /b

rem -----------------------------------------
rem ----------コメントの入力n行まで----------
rem -----------------------------------------
:Input3Comments
	:_WHILE1
		echo コミットコメント
		set comment1=
		set /p comment1="> "
		rem 1行目のコメント無き場合は終了-----
		:_WHILE2
			if "!comment1!"=="" (
				set /p ret=コミットをキャンセルしますか?[y/n]
				if !ret!==n (
					goto _WHILE1
				) else if not !ret!==y (
					goto _WHILE2
				) else (
					endlocal && set %1=none
					exit /b
				)
			)
		echo ^>%GREY% ^(this row is blank^)%WHITE%
		set /p comment3="> "
		set /p comment4="> "
		if "!comment3!"=="" ( set comment3=none ) 
		if "!comment4!"=="" ( set comment4=none )

		echo 以下のコメントでよろしいですか?
		echo   !comment1!
		if not !comment3!==none (
			echo   %GREY%^(blank row^)%WHITE%
			echo   !comment3!
		)
		if not !comment4!==none ( echo   !comment4! )
		)
		:_WHILE3
			set /p _ret="[y/n]"
			if !_ret!==n (
				goto _WHILE1
			) else if not !_ret!==y (
				goto _WHILE3
			)
	endlocal
	set %1=%comment1%
	set %2=%comment3%
	set %3=%comment4%
exit /b


rem -----------------------------------------
rem ----------コメントの入力n行まで----------
rem -----------------------------------------
:InputComments
	:__WHILE0
		set initFlag=true
		echo コメントを入力してください [eofのみ入力で終了]
		set comments=
		:__WHILE1
			set /p _comments=^> 
			if not !_comments!==eof (
				if !initFlag!==true (
					echo ^> %GREY%^(blank row^)%WHITE%
					set initFlag=false
				)
				set comments=!comments!CRLF!_comments!
				goto __WHILE1
			)
			echo !comments!
			if "!comments!"=="" (
				:__WHILE2
					set /p ret=コミットをキャンセルしますか[y/n] -^>
					if !ret!==y (
						endlocal && set %1=none
						exit /b
					) else if !ret!==n (
						goto __WHILE0
					)
					goto __WHILE2
			)
			:__WHILE3
				set /p ret=以上のコメントでよろしいですか[y/n] -^>
				if !ret!==n (
					goto __WHILE0
				) else if not !ret!==y (
					goto __WHILE3
				)
	endlocal && set %1=%comments%
exit /b


